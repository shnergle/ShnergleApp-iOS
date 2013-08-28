//
//  LoginScreenController.m
//  ShnergleApp
//
//  Created by Harshita Balaga on 26/04/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "LoginScreenController.h"
#import "Request.h"
#import <sys/utsname.h>

@implementation LoginScreenController

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (appDelegate.didShare != nil) {
        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AroundMeSlidingViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    appDelegate.didShare = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationController setNavigationBarHidden:YES];

    FBLoginView *loginView = [[FBLoginView alloc] initWithReadPermissions:@[@"email", @"user_birthday"]];
    loginView.delegate = self;
    loginView.frame = CGRectMake(160 - loginView.frame.size.width / 2, 354, loginView.frame.size.width, loginView.frame.size.height);
    [self.view addSubview:loginView];
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user {
    appDelegate.fullName = [NSString stringWithFormat:@"%@ %@", [self orEmpty:user.first_name], [self orEmpty:user.last_name]];
    appDelegate.facebookId = user.id;

    NSDictionary *params = @{@"facebook": [self orEmpty:user.username],
                             @"forename": [self orEmpty:user.first_name],
                             @"surname": [self orEmpty:user.last_name],
                             @"email": [self orEmpty:user[@"email"]],
                             @"gender": [self orEmpty:[user[@"gender"] substringToIndex:1]],
                             @"country": [self orEmpty:[[user[@"locale"] substringFromIndex:3] lowercaseString]],
                             @"language": [self orEmpty:user[@"locale"]],
                             @"app_version": [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"],
                             @"iphone_model": [self machineName],
                             @"ios_version": [UIDevice currentDevice].systemVersion,
                             @"birth_day": [self orEmpty:[user[@"birthday"] substringWithRange:NSMakeRange(3, 2)]],
                             @"birth_month": [self orEmpty:[user[@"birthday"] substringToIndex:2]],
                             @"birth_year": [self orEmpty:[user[@"birthday"] substringFromIndex:6]],
                             @"age": @([self age:user[@"birthday"]])};

    [Request post:@"users/set" params:params delegate:self callback:@selector(postResponse:)];
}

- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    [self alert];
}

- (NSString *)orEmpty:(NSString *)string {
    return string ? string : @"";
}

- (NSInteger)age:(NSString *)birthday {
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM/dd/yyyy";
    NSDate *birthdayDate = [dateFormatter dateFromString:birthday];
    NSDateComponents *ageComponents = [[NSCalendar currentCalendar]
                                       components:NSYearCalendarUnit
                                         fromDate:birthdayDate
                                           toDate:now
                                          options:0];
    return [ageComponents year];
}

- (NSString *)machineName {
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

- (void)postResponse:(NSDictionary *)response {
    if (response != nil) {
        if (![@"" isEqualToString : response[@"twitter"]]) appDelegate.twitter = response[@"twitter"];
        appDelegate.employee = [response[@"employee"] isEqual:@1];
        appDelegate.saveLocally = [response[@"save_locally"] intValue] == 1;
        appDelegate.optInTop5 = [response[@"top5"] intValue] == 1;
        newUser = [response[@"joined"] intValue] + 10 > [[NSDate date] timeIntervalSince1970];
        [Request post:@"rankings/get" params:nil delegate:self callback:@selector(gotRank:)];
    } else {
        [self alert];
    }
}

- (void)gotOwnVenues:(NSArray *)response {
    appDelegate.ownVenues = response;
    UIViewController *vc;
    if (newUser) {
        vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PrivacyView"];
    } else {
        vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AroundMeSlidingViewController"];
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)gotRank:(NSDictionary *)response {
    appDelegate.level = [response[@"level"] stringValue];
    [Request post:@"venues/get" params:@{@"own": @"true", @"level": appDelegate.level} delegate:self callback:@selector(gotOwnVenues:)];
}

- (void)alert {
    [[[UIAlertView alloc] initWithTitle:@"Connection failed!" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (IBAction)showInfo:(id)sender {
    [[[UIAlertView alloc] initWithTitle:nil message:@"We only take your most basic Facebook info so that we can provide you a service without asking you to fill in forms.\n\nWe will never post to Facebook without your express instruction.\nWe will never share your information with anybody other than in aggregated non-identifiable ways (e.g: '15% of males aged 18-24 attend your venue after seeing this image') without your express permission.\n\nFor more information please see our privacy policy." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

@end

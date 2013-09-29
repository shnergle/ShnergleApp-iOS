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
#import <FlurrySDK/Flurry.h>

@implementation LoginScreenController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    FBLoginView *loginView = [[FBLoginView alloc] initWithReadPermissions:@[@"email", @"user_birthday"]];
    loginView.delegate = self;
    loginView.frame = CGRectMake(160 - loginView.frame.size.width / 2, 284, loginView.frame.size.width, loginView.frame.size.height);
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

    [Flurry setAge:[params[@"age"] intValue]];
    if ([@"m" isEqualToString:params[@"gender"]] || [@"f" isEqualToString:params[@"gender"]]) [Flurry setGender:params[@"gender"]];

    [Request post:@"users/set" params:params callback:^(id response) {
        if (response != nil) {
            if (![response[@"twitter"] isKindOfClass:[NSNull class]] && ![@"" isEqualToString : response[@"twitter"]]) appDelegate.twitter = response[@"twitter"];
            appDelegate.employee = [response[@"employee"] integerValue] == 1;
            appDelegate.saveLocally = [response[@"save_locally"] integerValue] == 1;
            appDelegate.optInTop5 = [response[@"top5"] integerValue] == 1;
            appDelegate.lastFb = [response[@"last_facebook"] integerValue] == 1;
            appDelegate.lastTwitter = [response[@"last_twitter"] integerValue] == 1;
            newUser = [response[@"joined"] integerValue] + 10 > [[NSDate date] timeIntervalSince1970];
            [Request post:@"rankings/get" params:nil callback:^(id response) {
                appDelegate.level = [response[@"level"] stringValue];
                [Request post:@"venues/get" params:@{@"own": @"true", @"level": appDelegate.level} callback:^(id response) {
                    appDelegate.ownVenues = response;
                    UIViewController *vc;
                    if (newUser) {
                        vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PrivacyView"];
                    } else {
                        vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AroundMeSlidingViewController"];
                    }
                    [self.navigationController pushViewController:vc animated:YES];
                }];
            }];
        } else {
            [self alert];
        }
    }];
}

- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    [[[UIAlertView alloc] initWithTitle:@"Could not log in with Facebook. Ensure access is enabled in Privacy/Facebook settings and your Facebook account is properly set up." message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    loginView.hidden = YES;
    self.whyFacebookInfoButton.hidden = YES;
    self.whyFacebookLabel.hidden = YES;
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    loginView.hidden = NO;
    self.whyFacebookInfoButton.hidden = NO;
    self.whyFacebookLabel.hidden = NO;
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
    return @(systemInfo.machine);
}

- (void)alert {
    [[[UIAlertView alloc] initWithTitle:@"Connection failed!" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (IBAction)showInfo:(id)sender {
    [[[UIAlertView alloc] initWithTitle:nil message:@"We only take your most basic Facebook info so that we can provide you a service without asking you to fill in forms.\n\nWe will never post to Facebook without your express instruction.\nWe will never share your information with anybody other than in aggregated non-identifiable ways (e.g: '15% of males aged 18-24 attend your venue after seeing this image') without your express permission.\n\nFor more information please see our privacy policy." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

@end

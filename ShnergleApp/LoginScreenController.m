//
//  LoginScreenController.m
//  ShnergleApp
//
//  Created by Harshita Balaga on 26/04/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "LoginScreenController.h"
#import "PostRequest.h"
#import <FacebookSDK/FBLoginViewLoginButtonSmallPNG.h>
#import <FacebookSDK/FBLoginViewLoginButtonSmallPressedPNG.h>
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

    [self.buttonLoginLogout setBackgroundImage:[FBLoginViewLoginButtonSmallPNG image] forState:UIControlStateNormal];
    [self.buttonLoginLogout setBackgroundImage:[FBLoginViewLoginButtonSmallPressedPNG image] forState:UIControlStateHighlighted];

    [self.navigationController setNavigationBarHidden:YES];
    if (!appDelegate.session.isOpen) {
        self.buttonLoginLogout.hidden = YES;
        appDelegate.session = [[FBSession alloc] initWithAppID:nil permissions:@[@"email", @"user_birthday"] urlSchemeSuffix:nil tokenCacheStrategy:nil];
        if (appDelegate.session.state == FBSessionStateCreatedTokenLoaded) {
            [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                             FBSessionState status,
                                                             NSError *error) {
                [self updateView];
            }];
        } else {
            self.buttonLoginLogout.hidden = NO;
        }
    }
}

- (void)updateView {
    if (appDelegate.session.isOpen) {
        self.buttonLoginLogout.hidden = YES;

        [[[FBRequest alloc] initWithSession:appDelegate.session graphPath:@"me"] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary<FBGraphUser> *user,
           NSError *error) {
            if (!error) {
                appDelegate.fullName = [NSString stringWithFormat:@"%@ %@", user.first_name, user.last_name];
                appDelegate.facebookId = user.id;

                NSDictionary *params = @{@"facebook": user.username,
                                         @"forename": user.first_name,
                                         @"surname": user.last_name,
                                         @"email": user[@"email"],
                                         @"gender": [user[@"gender"] substringToIndex:1],
                                         @"country": [[user[@"locale"] substringFromIndex:3] lowercaseString],
                                         @"language": user[@"locale"],
                                         @"app_version": [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"],
                                         @"iphone_model": [self machineName],
                                         @"ios_version": [UIDevice currentDevice].systemVersion,
                                         @"birth_day": [user[@"birthday"] substringWithRange:NSMakeRange(3, 2)],
                                         @"birth_month": [user[@"birthday"] substringToIndex:2],
                                         @"birth_year": [user[@"birthday"] substringFromIndex:6],
                                         @"age": @([self age:user[@"birthday"]])};

                if (![[[PostRequest alloc] init] exec:@"users/set" params:params delegate:self callback:@selector(postResponse:)]) [self alert];
            } else {
                self.buttonLoginLogout.hidden = NO;
                [self alert];
            }
        }];
    } else {
        self.buttonLoginLogout.hidden = NO;
    }
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
        [[[PostRequest alloc] init] exec:@"rankings/get" params:nil delegate:self callback:@selector(gotRank:)];
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
    self.buttonLoginLogout.hidden = NO;
}

- (void)gotRank:(NSDictionary *)response {
    appDelegate.level = [response[@"level"] stringValue];
    [[[PostRequest alloc] init] exec:@"venues/get" params:@{@"own": @"true", @"level": appDelegate.level} delegate:self callback:@selector(gotOwnVenues:)];
}

- (IBAction)buttonClickHandler:(id)sender {
    self.buttonLoginLogout.hidden = YES;

    if (appDelegate.session.state != FBSessionStateCreated) appDelegate.session = [[FBSession alloc] initWithAppID:nil permissions:@[@"email", @"user_birthday"] urlSchemeSuffix:nil tokenCacheStrategy:nil];
    [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                     FBSessionState status,
                                                     NSError *error) {
        [self updateView];
    }];
}

- (void)viewDidDisappear:(BOOL)animated {
    self.buttonLoginLogout = nil;

    [super viewDidDisappear:animated];
}

- (void)alert {
    UIActionSheet *alert = [[UIActionSheet alloc] initWithTitle:@"Connection failed!" delegate:nil cancelButtonTitle:@"OK" destructiveButtonTitle:nil otherButtonTitles:nil];
    [alert showInView:[[self view] window]];
}

@end

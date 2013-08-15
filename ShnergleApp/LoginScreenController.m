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
                NSMutableString *params = [[NSMutableString alloc] initWithString:@"facebook="];
                [params appendString:user.username];
                [params appendString:@"&forename="];
                [params appendString:user.first_name];
                [params appendString:@"&surname="];
                [params appendString:user.last_name];
                [params appendString:@"&email="];
                [params appendString:user[@"email"]];
                [params appendString:@"&gender="];
                [params appendString:[user[@"gender"] substringToIndex:1]];
                [params appendString:@"&country="];
                [params appendString:[[user[@"locale"] substringFromIndex:3] lowercaseString]];
                [params appendString:@"&language="];
                [params appendString:user[@"locale"]];
                [params appendString:@"&app_version="];
                [params appendString:[[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"]];
                [params appendString:@"&iphone_model="];
                [params appendString:[self machineName]];
                [params appendString:@"&ios_version="];
                [params appendString:[UIDevice currentDevice].systemVersion];
                [params appendString:@"&birth_day="];
                [params appendString:[user[@"birthday"] substringWithRange:NSMakeRange(3, 2)]];
                [params appendString:@"&birth_month="];
                [params appendString:[user[@"birthday"] substringToIndex:2]];
                [params appendString:@"&birth_year="];
                [params appendString:[user[@"birthday"] substringFromIndex:6]];
                NSDate *now = [NSDate date];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                dateFormatter.dateFormat = @"MM/dd/yyyy";
                NSDate *birthday = [dateFormatter dateFromString:user[@"birthday"]];
                NSDateComponents *ageComponents = [[NSCalendar currentCalendar]
                                                   components:NSYearCalendarUnit
                                                     fromDate:birthday
                                                       toDate:now
                                                      options:0];
                NSInteger age = [ageComponents year];
                [params appendFormat:@"&age=%d", age];

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
        [[[PostRequest alloc] init] exec:@"rankings/get" params:@"" delegate:self callback:@selector(gotRank:)];
    } else {
        [self alert];
    }
}

- (void)gotOwnVenues:(NSArray *)response {
    appDelegate.ownVenues = response;
    UIViewController *vc;
    if (true /*newUser*/) {
        vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PrivacyView"];
    } else {
        vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AroundMeSlidingViewController"];
    }
    [self.navigationController pushViewController:vc animated:YES];
    self.buttonLoginLogout.hidden = NO;
}

- (void)gotRank:(NSDictionary *)response {
    appDelegate.level = [response[@"level"] stringValue];
    [[[PostRequest alloc] init] exec:@"venues/get" params:[NSString stringWithFormat:@"own=true&level=%@", appDelegate.level] delegate:self callback:@selector(gotOwnVenues:)];
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

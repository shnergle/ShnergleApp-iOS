//
//  LoginScreenController.m
//  ShnergleApp
//
//  Created by Harshita Balaga on 26/04/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "LoginScreenController.h"
#import "PostRequest.h"

@implementation LoginScreenController

- (void)viewWillAppear:(BOOL)animated {
    [[self navigationController] setNavigationBarHidden:YES];
    if (appDelegate.didShare != nil) {
        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AroundMeSlidingViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    appDelegate.didShare = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.buttonLoginLogout setBackgroundImage:[UIImage imageNamed:@"login-button-small.png"] forState:UIControlStateNormal];
    [self.buttonLoginLogout setBackgroundImage:[UIImage imageNamed:@"login-button-small-pressed.png"] forState:UIControlStateHighlighted];

    [[self navigationController] setNavigationBarHidden:YES];
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

        //login on server
        [[[FBRequest alloc] initWithSession:appDelegate.session graphPath:@"me"] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary<FBGraphUser> *user,
           NSError *error) {
            if (!error) {
                appDelegate.fullName = [NSString stringWithFormat:@"%@ %@", user.first_name, user.last_name];
                appDelegate.facebookId = user.id;
                appDelegate.email = user[@"email"];
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
                [params appendString:@"&birth_day="];
                [params appendString:[user[@"birthday"] substringWithRange:NSMakeRange(3, 2)]];
                [params appendString:@"&birth_month="];
                [params appendString:[user[@"birthday"] substringToIndex:2]];
                [params appendString:@"&birth_year="];
                [params appendString:[user[@"birthday"] substringFromIndex:6]];
                NSDate *now = [NSDate date];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"MM/dd/yyyy"];
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

- (void)postResponse:(id)response {
    if (response) {
        if (![@"" isEqualToString:((NSDictionary *)response)[@"twitter"]]) appDelegate.twitter = ((NSDictionary *)response)[@"twitter"];
        appDelegate.saveLocally = [((NSDictionary *)response)[@"save_locally"] intValue] == 1;
        appDelegate.optInTop5 = [((NSDictionary *)response)[@"top5"] intValue] == 1;
        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AroundMeSlidingViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [self alert];
    }
    self.buttonLoginLogout.hidden = NO;
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

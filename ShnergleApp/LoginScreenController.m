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

    //HideNavBar
    [[self navigationController] setNavigationBarHidden:YES];
    if (!appDelegate.session.isOpen) {
        self.buttonLoginLogout.hidden = YES;
        // create a fresh session object
        appDelegate.session = [[FBSession alloc] initWithAppID:nil permissions:@[@"email", @"user_birthday"] urlSchemeSuffix:nil tokenCacheStrategy:nil];

        // if we don't have a cached token, a call to open here would cause UX for login to
        // occur; we don't want that to happen unless the user clicks the login button, and so
        // we check here to make sure we have a token before calling open
        if (appDelegate.session.state == FBSessionStateCreatedTokenLoaded) {
            // even though we had a cached token, we need to login to make the session usable
            [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                             FBSessionState status,
                                                             NSError *error) {
                // we recurse here, in order to update buttons and labels
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
                NSMutableString *params = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"facebook_id=%@", appDelegate.facebookId]];
                [params appendString:@"&facebook="];
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
                [params appendString:@"&age="];
                [params appendString:[NSString stringWithFormat:@"%d", age]];

                if (![[[PostRequest alloc] init] exec:@"users/set" params:params delegate:self callback:@selector(postResponse:) type:@"string"]) [self alert];
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
    if ([response isEqual:@"true"]) {
        NSString *params = [NSString stringWithFormat:@"facebook_id=%@", appDelegate.facebookId];
        if (![[[PostRequest alloc] init] exec:@"users/get" params:params delegate:self callback:@selector(getResponse:)]) [self alert];
    } else {
        [self alert];
    }
}

- (void)getResponse:(id)response {
    if (response) {
        if (![((NSDictionary *)response)[@"twitter"] isEqual : @""]) appDelegate.twitter = ((NSDictionary *)response)[@"twitter"];
        if ([((NSDictionary *)response)[@"save_locally"] isEqual : @1]) appDelegate.saveLocally = YES;
        else appDelegate.saveLocally = NO;
        if ([((NSDictionary *)response)[@"top5"] isEqual : @1]) appDelegate.optInTop5 = YES;
        else appDelegate.optInTop5 = NO;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)alert {
    UIActionSheet *alert = [[UIActionSheet alloc] initWithTitle:@"Connection failed!" delegate:nil cancelButtonTitle:@"OK" destructiveButtonTitle:nil otherButtonTitles:nil];
    [alert showInView:[[self view] window]];
}

@end

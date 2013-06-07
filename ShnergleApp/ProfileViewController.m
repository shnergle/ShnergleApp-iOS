//
//  ProfileViewController.m
//  ShnergleApp
//
//  Created by Harshita Balaga on 03/05/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "ProfileViewController.h"
#import "AppDelegate.h"
#import "PostRequest.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setRightBarButton:@"Sign out" actionSelector:@selector(signOut)];

    AppDelegate *appdelegate = [[UIApplication sharedApplication]delegate];
    self.navigationItem.title = appdelegate.fullName;
    self.userProfileImage3.profileID = appdelegate.facebookId;
    //self.userProfileImage2.profileID = appdelegate.facebookId;
    //self.userProfileImage1.profileID = appdelegate.facebookId;
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if (appDelegate.twitter)
        _twitterSwitch.on = YES;
    _checkInView.layer.borderColor = [UIColor colorWithRed:134.0/255 green:134.0/255 blue:134.0/255 alpha:1].CGColor;
    _checkInView.layer.borderWidth = 2;
    _redeemed.layer.borderColor = [UIColor colorWithRed:134.0/255 green:134.0/255 blue:134.0/255 alpha:1].CGColor;
    _redeemed.layer.borderWidth = 2;
    _favourites.layer.borderColor = [UIColor colorWithRed:134.0/255 green:134.0/255 blue:134.0/255 alpha:1].CGColor;
    _favourites.layer.borderWidth = 2;
    _scoutView.backgroundColor = [UIColor colorWithRed:34.0/255 green:148.0/255 blue:221.0/255 alpha:1];
    _userProfileImage3.hidden = NO;
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //Sketchy! Look out for bugs. this is done to hide the navbar beautifully when navigating back to main page or login page
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}



- (void)signOut {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.session closeAndClearTokenInformation];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)twitterSwitchAction:(id)sender {
    __block int count = 0;
    NSDate *start = [NSDate date];
    NSLog(@"TIMING - %d - %f", count++, [[NSDate date] timeIntervalSinceDate:start]);
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSLog(@"TIMING - %d - %f", count++, [[NSDate date] timeIntervalSinceDate:start]);
    id delegateMe = self;
    NSLog(@"TIMING - %d - %f", count++, [[NSDate date] timeIntervalSinceDate:start]);
    ProfileViewController *me = self;
    NSLog(@"TIMING - %d - %f", count++, [[NSDate date] timeIntervalSinceDate:start]);
    if (_twitterSwitch.on) {
        NSLog(@"TIMING - %d - %f", count++, [[NSDate date] timeIntervalSinceDate:start]);
        ACAccountStore *accountStore = [[ACAccountStore alloc] init];
        NSLog(@"TIMING - %d - %f", count++, [[NSDate date] timeIntervalSinceDate:start]);
        ACAccountType *twitterAccountType = [accountStore
                                             accountTypeWithAccountTypeIdentifier:
                                             ACAccountTypeIdentifierTwitter];
        NSLog(@"TIMING - %d - %f", count++, [[NSDate date] timeIntervalSinceDate:start]);
        [accountStore
         requestAccessToAccountsWithType:twitterAccountType
         options:NULL
         completion:^(BOOL granted, NSError *error) {
             NSLog(@"TIMING - %d - %f", count++, [[NSDate date] timeIntervalSinceDate:start]);
             if (granted) {
                 NSLog(@"TIMING - %d - %f", count++, [[NSDate date] timeIntervalSinceDate:start]);
                 me.accounts = [accountStore accountsWithAccountType:twitterAccountType];
                 NSLog(@"TIMING - %d - %f", count++, [[NSDate date] timeIntervalSinceDate:start]);
                 switch (me.accounts.count) {
                         NSLog(@"TIMING - %d - %f", count++, [[NSDate date] timeIntervalSinceDate:start]);
                     case 0:
                     {
                         NSLog(@"TIMING - %d - %f", count++, [[NSDate date] timeIntervalSinceDate:start]);
                         [self alertTwitter];
                         NSLog(@"TIMING - %d - %f", count++, [[NSDate date] timeIntervalSinceDate:start]);
                         break;
                     }
                     case 1:
                     {
                         appDelegate.twitter = [me.accounts.lastObject username];
                         NSLog(@"TIMING - %d - %f", count++, [[NSDate date] timeIntervalSinceDate:start]);
                         NSString *params = [NSString stringWithFormat:@"facebook_id=%@&twitter=%@", appDelegate.facebookId, appDelegate.twitter];
                         NSLog(@"TIMING - %d - %f", count++, [[NSDate date] timeIntervalSinceDate:start]);
                         if (![[[PostRequest alloc] init] exec:@"users/set" params:params delegate:self callback:@selector(twitterReq:) type:@"string"]) {
                             NSLog(@"TIMING - %d - %f", count++, [[NSDate date] timeIntervalSinceDate:start]);
                             [self alertTwitter];
                             NSLog(@"TIMING - %d - %f", count++, [[NSDate date] timeIntervalSinceDate:start]);
                         }
                         break;
                     }
                     default:
                     {
                         NSLog(@"TIMING - %d - %f", count++, [[NSDate date] timeIntervalSinceDate:start]);
                         UIActionSheet *alert = [[UIActionSheet alloc] initWithTitle:@"Select Twitter Account" delegate:delegateMe cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
                         NSLog(@"TIMING - %d - %f", count++, [[NSDate date] timeIntervalSinceDate:start]);
                         for (ACAccount *acc in me.accounts)
                             [alert addButtonWithTitle:acc.username];
                         NSLog(@"TIMING - %d - %f", count++, [[NSDate date] timeIntervalSinceDate:start]);
                         [alert addButtonWithTitle:@"Cancel"];
                         NSLog(@"TIMING - %d - %f", count++, [[NSDate date] timeIntervalSinceDate:start]);
                         [alert showInView:self.view.window];
                         NSLog(@"TIMING - %d - %f", count++, [[NSDate date] timeIntervalSinceDate:start]);
                     }
                 }
             } else [self alertTwitter];
         }];
    } else {
        NSLog(@"TIMING - %d - %f", count++, [[NSDate date] timeIntervalSinceDate:start]);
        appDelegate.twitter = nil;
        NSLog(@"TIMING - %d - %f", count++, [[NSDate date] timeIntervalSinceDate:start]);
        NSString *params = [NSString stringWithFormat:@"facebook_id=%@&twitter=", appDelegate.facebookId];
        NSLog(@"TIMING - %d - %f", count++, [[NSDate date] timeIntervalSinceDate:start]);
        if (![[[PostRequest alloc] init] exec:@"users/set" params:params delegate:self callback:@selector(twitterReq:) type:@"string"]) {
            [self alertTwitter];
        }
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if (buttonIndex == _accounts.count) {
        _twitterSwitch.on = NO;
    } else {
        NSString *twitter = [_accounts[buttonIndex] username];
        appDelegate.twitter = twitter;
        NSString *params = [NSString stringWithFormat:@"facebook_id=%@&twitter=%@", appDelegate.facebookId, twitter];
        if (![[[PostRequest alloc] init] exec:@"users/set" params:params delegate:self callback:@selector(twitterReq:) type:@"string"]) {
            [self alertTwitter];
        }

    }
}

- (void)twitterReq:(id)response {
    if (![response isEqual:@"true"])
        [self alertTwitter];
}


- (void)alertTwitter {
    _twitterSwitch.on = !_twitterSwitch.on;
    UIActionSheet *alert = [[UIActionSheet alloc] initWithTitle:@"Twitter (de)activation failed!" delegate:nil cancelButtonTitle:@"OK" destructiveButtonTitle:nil otherButtonTitles:nil];
    [alert showInView:[[self view] window]];
}

@end

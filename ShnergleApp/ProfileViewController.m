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
    self.userProfileImage.profileID = appdelegate.facebookId;
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if (appDelegate.twitter)
        _twitterSwitch.on = YES;
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
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    id delegateMe = self;
    ProfileViewController *me = self;
    if (_twitterSwitch.on) {
        ACAccountStore *accountStore = [[ACAccountStore alloc] init];
        ACAccountType *twitterAccountType = [accountStore
                                             accountTypeWithAccountTypeIdentifier:
                                             ACAccountTypeIdentifierTwitter];
        [accountStore
         requestAccessToAccountsWithType:twitterAccountType
         options:NULL
         completion:^(BOOL granted, NSError *error) {
             if (granted) {
                 me.accounts = [accountStore accountsWithAccountType:twitterAccountType];
                 switch (me.accounts.count) {
                     case 0:
                     {
                         [self alertTwitter];
                         break;
                     }
                     case 100:
                     {
                         appDelegate.twitter = [me.accounts.lastObject username];
                         NSString *params = [NSString stringWithFormat:@"facebook_id=%@&twitter=%@", appDelegate.facebookId, appDelegate.twitter];
                         if (![[[PostRequest alloc] init] exec:@"users/set" params:params delegate:self callback:@selector(twitterReq:) type:@"string"]) {
                             [self alertTwitter];
                         }
                         break;
                     }
                     default:
                     {
                         UIActionSheet *alert = [[UIActionSheet alloc] initWithTitle:@"Select Twitter Account" delegate:delegateMe cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
                         for (ACAccount *acc in me.accounts)
                             [alert addButtonWithTitle:acc.username];
                         [alert addButtonWithTitle:@"Cancel"];
                         [alert showInView:self.view.window];
                     }
                 }
             } else [self alertTwitter];
         }];
    } else {
        appDelegate.twitter = nil;
        NSString *params = [NSString stringWithFormat:@"facebook_id=%@&twitter=", appDelegate.facebookId];
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

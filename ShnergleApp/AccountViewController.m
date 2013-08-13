//
//  AccountViewController.m
//  ShnergleApp
//
//  Created by Harshita Balaga on 12/08/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "AccountViewController.h"
#import <Toast/Toast+UIView.h>
#import "PostRequest.h"

@implementation AccountViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.title = @"Account Settings";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.saveLocallySwitch.on = appDelegate.saveLocally;
    self.optInSwitch.on = appDelegate.optInTop5;
    self.twitterSwitch.on = appDelegate.twitter != nil;
}

- (IBAction)optInChange:(id)sender {
    [self.view makeToastActivity];
    appDelegate.optInTop5 = self.optInSwitch.on;
    [[[PostRequest alloc] init] exec:@"users/set" params:[NSString stringWithFormat:@"top5=%@", (self.optInSwitch.on ? @"true" : @"false")] delegate:self callback:@selector(doNothing:)];
}

- (IBAction)saveLocallyChange:(id)sender {
    [self.view makeToastActivity];
    appDelegate.saveLocally = self.saveLocallySwitch.on;
    [[[PostRequest alloc] init] exec:@"users/set" params:[NSString stringWithFormat:@"save_locally=%@", (self.saveLocallySwitch.on ? @"true" : @"false")] delegate:self callback:@selector(doNothing:)];
}

- (IBAction)twitterSwitchAction:(id)sender {
    [self.view makeToastActivity];
    if (self.twitterSwitch.on) {
        ACAccountStore *accountStore = [[ACAccountStore alloc] init];
        ACAccountType *twitterType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];

        ACAccountStoreRequestAccessCompletionHandler accountStoreHandler =
        ^(BOOL granted, NSError *error) {
            if (granted) {
                NSArray *accounts = [accountStore accountsWithAccountType:twitterType];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter Account" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                for (ACAccount *account in accounts) {
                    [alert addButtonWithTitle:[NSString stringWithFormat:@"@%@", account.username]];
                }
                [self.view hideToastActivity];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [alert show];
                });
            } else {
                NSLog(@"[ERROR] An error occurred while asking for user authorization: %@",
                      [error localizedDescription]);
            }
        };

        [accountStore requestAccessToAccountsWithType:twitterType
                                              options:NULL
                                           completion:accountStoreHandler];
    } else {
        appDelegate.twitter = nil;
        [[[PostRequest alloc] init] exec:@"users/set" params:@"twitter=" delegate:self callback:@selector(doNothing:)];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self.view makeToastActivity];
    if (buttonIndex == alertView.cancelButtonIndex) {
        self.twitterSwitch.on = NO;
    } else {
        appDelegate.twitter = [[alertView buttonTitleAtIndex:buttonIndex] stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
        [[[PostRequest alloc] init] exec:@"users/set" params:[NSString stringWithFormat:@"twitter=%@", appDelegate.twitter] delegate:self callback:@selector(doNothing:)];
    }
}

- (void)doNothing:(id)whoCares {
    [self.view hideToastActivity];
}

@end

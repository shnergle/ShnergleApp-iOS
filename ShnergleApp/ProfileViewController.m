//
//  ProfileViewController.m
//  ShnergleApp
//
//  Created by Harshita Balaga on 03/05/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "ProfileViewController.h"
#import "PostRequest.h"
#import "MenuViewController.h"
#import <Toast/Toast+UIView.h>
#import <ECSlidingViewController.h>
#import <Accounts/Accounts.h>

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self menuButtonDecorations];

    self.navigationItem.title = appDelegate.fullName;
    self.userProfileImage3.profileID = appDelegate.facebookId;
    self.userProfileImage2.profileID = appDelegate.facebookId;
    self.userProfileImage1.profileID = appDelegate.facebookId;

    self.checkInView.layer.borderColor = [UIColor colorWithRed:134.0 / 255 green:134.0 / 255 blue:134.0 / 255 alpha:1].CGColor;
    self.checkInView.layer.borderWidth = 2;
    self.redeemed.layer.borderColor = [UIColor colorWithRed:134.0 / 255 green:134.0 / 255 blue:134.0 / 255 alpha:1].CGColor;
    self.redeemed.layer.borderWidth = 2;
    self.favourites.layer.borderColor = [UIColor colorWithRed:134.0 / 255 green:134.0 / 255 blue:134.0 / 255 alpha:1].CGColor;
    self.favourites.layer.borderWidth = 2;
    self.userProfileImage3.hidden = YES;
    self.userProfileImage3.layer.borderColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:1].CGColor;
    self.userProfileImage3.layer.borderWidth = 2;
    self.userProfileImage2.layer.borderColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:1].CGColor;
    self.userProfileImage2.layer.borderWidth = 2;
    self.userProfileImage1.layer.borderColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:1].CGColor;
    self.userProfileImage1.layer.borderWidth = 2;

    self.saveLocallySwitch.on = appDelegate.saveLocally;
    self.optInSwitch.on = appDelegate.optInTop5;

    self.twitterSwitch.on = appDelegate.twitter != nil;
}

- (IBAction)optInChange:(id)sender {
    [self.view makeToastActivity];

    appDelegate.optInTop5 = self.optInSwitch.on;
    [[[PostRequest alloc] init] exec:@"users/set" params:[NSString stringWithFormat:@"top5=%@", (self.optInSwitch.on ? @"true" : @"false")] delegate:self callback:@selector(doNothing:)];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ProfileFavouritesSegue"]) {
        appDelegate.topViewType = @"Following";
    }
}

- (IBAction)saveLocallyChange:(id)sender {
    [self.view makeToastActivity];

    appDelegate.saveLocally = self.saveLocallySwitch.on;
    [[[PostRequest alloc] init] exec:@"users/set" params:[NSString stringWithFormat:@"save_locally=%@", (self.saveLocallySwitch.on ? @"true" : @"false")] delegate:self callback:@selector(doNothing:)];
}

- (void)doNothing:(id)whoCares {
    [self.view hideToastActivity];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.view makeToastActivity];

    [self menuButtonDecorations];
    [self decorateSignOutButton];
    self.navigationItem.hidesBackButton = YES;

    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"AroundMeMenu"];
    }
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    [self.slidingViewController setAnchorRightRevealAmount:230.0f];

    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;

    self.navigationController.navigationBar.clipsToBounds = YES;
    self.navBar.clipsToBounds = YES;

    [[[PostRequest alloc] init] exec:@"rankings/get" params:@"" delegate:self callback:@selector(postResponse:)];
}

- (void)postResponse:(NSDictionary *)result {
    int res = [result[@"level"] intValue];
    switch (res) {
        case 1:
            self.userProfileImage1.hidden = NO;
            break;
        case 2:
            self.userProfileImage2.hidden = NO;
            break;
        case 3:
            self.userProfileImage3.hidden = NO;
        default:
            break;
    }
    self.followingLabel.text = [self suffix:[result[@"following_total"] intValue]];
    self.redeemedLabel.text = [self suffix:[result[@"redemptions_total"]  intValue]];
    self.checkInLabel.text = [self suffix:[result[@"posts_total"]  intValue]];
    self.shnerglerLabel.text = [NSString stringWithFormat:@"Shnergle score above %@", [result[@"thresholds"][2] stringValue]];
    self.explorerLabel.text = [NSString stringWithFormat:@"Shnergle score above %@", [result[@"thresholds"][0] stringValue]];
    self.scoutLabel.text = [NSString stringWithFormat:@"Shnergle score above %@", [result[@"thresholds"][1] stringValue]];

    self.totalScore.text = [result[@"score"] stringValue];

    appDelegate.checkIn = [result[@"posts"] stringValue];
    appDelegate.youShare = [result[@"share"] stringValue];
    appDelegate.totalScore = [result[@"score"] stringValue];
    appDelegate.rsvp = [result[@"rsvps"] stringValue];
    appDelegate.comment = [result[@"comments"] stringValue];
    appDelegate.like = [result[@"likes"] stringValue];
    [self.view hideToastActivity];
}

- (NSString *)suffix:(int)number {
    if (number > 999999) {
        return [NSString stringWithFormat:@"%dM", number / 1000000];
    } else if (number > 999) {
        return [NSString stringWithFormat:@"%dK", number / 1000];
    } else {
        return [@(number)stringValue];
    }
}

- (IBAction)privacy:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.shnergle.com/"]];
}

- (void)tapMenu {
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (IBAction)signOut:(id)sender {
    [appDelegate.session closeAndClearTokenInformation];
    [self.navigationController popToRootViewControllerAnimated:YES];
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

- (UIBarButtonItem *)createLeftBarButton:(NSString *)imageName actionSelector:(SEL)actionSelector {
    UIImage *menuButtonImg = [UIImage imageNamed:imageName];

    UIButton *menuButtonTmp = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButtonTmp.frame = CGRectMake(280.0, 10.0, 22.0, 22.0);
    [menuButtonTmp setBackgroundImage:menuButtonImg forState:UIControlStateNormal];
    [menuButtonTmp addTarget:self action:actionSelector forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:menuButtonTmp];
    return menuButton;
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

- (void)menuButtonDecorations {
    SEL actionSelector = @selector(tapMenu);
    NSString *imageName = @"mainmenu_button.png";

    UIBarButtonItem *menuButton;
    menuButton = [self createLeftBarButton:imageName actionSelector:actionSelector];

    self.navBarItem.leftBarButtonItem = menuButton;
    self.navigationItem.leftBarButtonItem = menuButton;
}

- (void)decorateSignOutButton {
    [self.navBarItem.rightBarButtonItem setTitleTextAttributes:
     @{UITextAttributeTextColor: [UIColor blackColor],
       UITextAttributeTextShadowColor: [UIColor clearColor],
       UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, 0)],
       UITextAttributeFont: [UIFont systemFontOfSize:14.0]}
                                                      forState:UIControlStateNormal];
}

@end

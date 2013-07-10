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

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self menuButtonDecorations];


    self.navigationItem.title = appDelegate.fullName;
    self.userProfileImage3.profileID = appDelegate.facebookId;
    self.userProfileImage2.profileID = appDelegate.facebookId;
    self.userProfileImage1.profileID = appDelegate.facebookId;

    _checkInView.layer.borderColor = [UIColor colorWithRed:134.0 / 255 green:134.0 / 255 blue:134.0 / 255 alpha:1].CGColor;
    _checkInView.layer.borderWidth = 2;
    _redeemed.layer.borderColor = [UIColor colorWithRed:134.0 / 255 green:134.0 / 255 blue:134.0 / 255 alpha:1].CGColor;
    _redeemed.layer.borderWidth = 2;
    _favourites.layer.borderColor = [UIColor colorWithRed:134.0 / 255 green:134.0 / 255 blue:134.0 / 255 alpha:1].CGColor;
    _favourites.layer.borderWidth = 2;
    _userProfileImage3.hidden = YES;
    _userProfileImage3.layer.borderColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:1].CGColor;
    _userProfileImage3.layer.borderWidth = 2;
    _userProfileImage2.layer.borderColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:1].CGColor;
    _userProfileImage2.layer.borderWidth = 2;
    _userProfileImage1.layer.borderColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:1].CGColor;
    _userProfileImage1.layer.borderWidth = 2;

    self.saveLocallySwitch.on = appDelegate.saveLocally;
    self.optInSwitch.on = appDelegate.optInTop5;
}

- (IBAction)optInChange:(id)sender {
    [self.view makeToastActivity];

    appDelegate.optInTop5 = self.optInSwitch.on;
    [[[PostRequest alloc] init] exec:@"users/set" params:[NSString stringWithFormat:@"facebook_id=%@&top5=%@", appDelegate.facebookId, (self.optInSwitch.on ? @"true" : @"false")] delegate:self callback:@selector(doNothing:)];
}

- (IBAction)saveLocallyChange:(id)sender {
    [self.view makeToastActivity];

    appDelegate.saveLocally = self.saveLocallySwitch.on;
    [[[PostRequest alloc] init] exec:@"users/set" params:[NSString stringWithFormat:@"facebook_id=%@&save_locally=%@", appDelegate.facebookId, (self.saveLocallySwitch.on ? @"true" : @"false")] delegate:self callback:@selector(doNothing:)];
}

- (void)doNothing:(id)whoCares {
    [self.view hideToastActivity];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self menuButtonDecorations];
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

    NSMutableString *params = [[NSMutableString alloc] initWithString:@"facebook_id=549445495"];
    [[[PostRequest alloc] init] exec:@"rankings/get" params:params delegate:self callback:@selector(postResponse:) type:@"string"];
}

- (void)postResponse:(id)result {
    int res = [result integerValue];
    switch (res) {
        case 1:
            _userProfileImage1.hidden = NO;
            break;
        case 2:
            _userProfileImage2.hidden = NO;
            break;
        case 3:
            _userProfileImage3.hidden = NO;
        default:
            break;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)tapMenu {
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (IBAction)signOut:(id)sender {
    [appDelegate.session closeAndClearTokenInformation];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)twitterSwitchAction:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Twitter, tsk!" delegate:nil cancelButtonTitle:@"Yeah, I'm gonna use Facebook then!" destructiveButtonTitle:nil otherButtonTitles:nil];
    [actionSheet showInView:self.view.window];
}

- (UIBarButtonItem *)createLeftBarButton:(NSString *)imageName actionSelector:(SEL)actionSelector {
    UIImage *menuButtonImg = [UIImage imageNamed:imageName];

    UIButton *menuButtonTmp = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButtonTmp.frame = CGRectMake(280.0, 10.0, 22.0, 22.0);
    [menuButtonTmp setBackgroundImage:menuButtonImg forState:UIControlStateNormal];
    [menuButtonTmp addTarget:self action:actionSelector forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc]initWithCustomView:menuButtonTmp];
    return menuButton;
}

- (void)menuButtonDecorations {
    SEL actionSelector = @selector(tapMenu);
    NSString *imageName = @"mainmenu_button.png";

    UIBarButtonItem *menuButton;
    menuButton = [self createLeftBarButton:imageName actionSelector:actionSelector];

    self.navBarItem.leftBarButtonItem = menuButton;
    self.navigationItem.leftBarButtonItem = menuButton;
}

@end

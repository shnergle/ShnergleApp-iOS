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
#import "MenuViewController.h"
@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self menuButtonDecorations];

    //[self setRightBarButton:@"Sign out" actionSelector:@selector(signOut)];

    AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
    self.navigationItem.title = appdelegate.fullName;
    self.userProfileImage3.profileID = appdelegate.facebookId;
    //self.userProfileImage2.profileID = appdelegate.facebookId;
    //self.userProfileImage1.profileID = appdelegate.facebookId;
    //AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    //if (appDelegate.twitter)
    //    _twitterSwitch.on = YES;
    _checkInView.layer.borderColor = [UIColor colorWithRed:134.0 / 255 green:134.0 / 255 blue:134.0 / 255 alpha:1].CGColor;
    _checkInView.layer.borderWidth = 2;
    _redeemed.layer.borderColor = [UIColor colorWithRed:134.0 / 255 green:134.0 / 255 blue:134.0 / 255 alpha:1].CGColor;
    _redeemed.layer.borderWidth = 2;
    _favourites.layer.borderColor = [UIColor colorWithRed:134.0 / 255 green:134.0 / 255 blue:134.0 / 255 alpha:1].CGColor;
    _favourites.layer.borderWidth = 2;
    _scoutView.backgroundColor = [UIColor colorWithRed:34.0 / 255 green:148.0 / 255 blue:221.0 / 255 alpha:1];
    _userProfileImage3.hidden = NO;
    _userProfileImage3.layer.borderColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:1].CGColor;
    _userProfileImage3.layer.borderWidth = 2;
    _userProfileImage2.layer.borderColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:1].CGColor;
    _userProfileImage2.layer.borderWidth = 2;
    _userProfileImage1.layer.borderColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:1].CGColor;
    _userProfileImage1.layer.borderWidth = 2;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self menuButtonDecorations];
    self.navigationItem.hidesBackButton = YES;

    //THE SANDWICH MENU SYSTEM (ECSlidingViewController)
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"AroundMeMenu"];
    }
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    [self.slidingViewController setAnchorRightRevealAmount:230.0f];

    // Shadow for sandwich system
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;

    //Remove shadows for navbar
    self.navigationController.navigationBar.clipsToBounds = YES;
    self.navBar.clipsToBounds = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)tapMenu {
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (IBAction)signOut:(id)sender {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
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

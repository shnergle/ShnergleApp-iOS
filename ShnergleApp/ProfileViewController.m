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

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setRightBarButton:@"Sign out" actionSelector:@selector(signOut)];

    AppDelegate *appdelegate = [[UIApplication sharedApplication]delegate];
    self.navigationItem.title = appdelegate.fullName;
    self.userProfileImage3.profileID = appdelegate.facebookId;
    //self.userProfileImage2.profileID = appdelegate.facebookId;
    //self.userProfileImage1.profileID = appdelegate.facebookId;
    //AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    //if (appDelegate.twitter)
    //    _twitterSwitch.on = YES;
    _checkInView.layer.borderColor = [UIColor colorWithRed:134.0/255 green:134.0/255 blue:134.0/255 alpha:1].CGColor;
    _checkInView.layer.borderWidth = 2;
    _redeemed.layer.borderColor = [UIColor colorWithRed:134.0/255 green:134.0/255 blue:134.0/255 alpha:1].CGColor;
    _redeemed.layer.borderWidth = 2;
    _favourites.layer.borderColor = [UIColor colorWithRed:134.0/255 green:134.0/255 blue:134.0/255 alpha:1].CGColor;
    _favourites.layer.borderWidth = 2;
    _scoutView.backgroundColor = [UIColor colorWithRed:34.0/255 green:148.0/255 blue:221.0/255 alpha:1];
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
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Twitter, tsk!" delegate:nil cancelButtonTitle:@"Yeah, I'm gonna use Facebook then!" destructiveButtonTitle:nil otherButtonTitles:nil];
    [actionSheet showInView:self.view.window];
}

@end

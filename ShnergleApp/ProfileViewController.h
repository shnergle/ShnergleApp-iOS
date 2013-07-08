//
//  ProfileViewController.h
//  ShnergleApp
//
//  Created by Harshita Balaga on 03/05/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "CustomBackViewController.h"
#import <ECSlidingViewController.h>

@interface ProfileViewController : UIViewController <UIActionSheetDelegate>

//- (IBAction)authButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UISwitch *optInSwitch;
@property (strong, nonatomic) IBOutlet FBProfilePictureView *userProfileImage3;
@property (strong, nonatomic) IBOutlet FBProfilePictureView *userProfileImage1;
@property (strong, nonatomic) IBOutlet FBProfilePictureView *userProfileImage2;
@property (weak, nonatomic) IBOutlet UINavigationItem *navBarItem;
@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;

//@property (strong, nonatomic) FBProfilePictureView *profilePictureView;
@property (strong, nonatomic) IBOutlet UISwitch *twitterSwitch;
@property (strong, nonatomic) NSArray *accounts;
@property (weak, nonatomic) IBOutlet UIView *checkInView;
@property (weak, nonatomic) IBOutlet UIView *redeemed;
@property (weak, nonatomic) IBOutlet UIView *favourites;
@property (weak, nonatomic) IBOutlet UIView *scoutView;
@property (weak, nonatomic) IBOutlet UIView *shnerglerView;
@property (weak, nonatomic) IBOutlet UIView *explorerView;
@property (weak, nonatomic) IBOutlet UISwitch *saveLocallySwitch;

- (IBAction)twitterSwitchAction:(id)sender;
- (IBAction)signOut:(id)sender;

@end

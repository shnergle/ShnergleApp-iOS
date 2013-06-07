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

@interface ProfileViewController : CustomBackViewController <UIActionSheetDelegate>

//- (IBAction)authButtonAction:(id)sender;

@property (strong, nonatomic) IBOutlet FBProfilePictureView *userProfileImage3;
@property (strong, nonatomic) IBOutlet FBProfilePictureView *userProfileImage1;
@property (strong, nonatomic) IBOutlet FBProfilePictureView *userProfileImage2;

//@property (strong, nonatomic) FBProfilePictureView *profilePictureView;
@property (strong, nonatomic) IBOutlet UISwitch *twitterSwitch;
- (IBAction)twitterSwitchAction:(id)sender;
@property (strong, nonatomic) NSArray *accounts;
@property (weak, nonatomic) IBOutlet UIView *checkInView;
@property (weak, nonatomic) IBOutlet UIView *redeemed;
@property (weak, nonatomic) IBOutlet UIView *favourites;
@property (weak, nonatomic) IBOutlet UIView *scoutView;
@property (weak, nonatomic) IBOutlet UIView *shnerglerView;
@property (weak, nonatomic) IBOutlet UIView *explorerView;

@end

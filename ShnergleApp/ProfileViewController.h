//
//  ProfileViewController.h
//  ShnergleApp
//
//  Created by Harshita Balaga on 03/05/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>
#import "CustomBackViewController.h"

@interface ProfileViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *checkInLabel;
@property (weak, nonatomic) IBOutlet UILabel *redeemedLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingLabel;
@property (strong, nonatomic) IBOutlet FBProfilePictureView *userProfileImage3;
@property (strong, nonatomic) IBOutlet FBProfilePictureView *userProfileImage1;
@property (strong, nonatomic) IBOutlet FBProfilePictureView *userProfileImage2;
@property (weak, nonatomic) IBOutlet UINavigationItem *navBarItem;
@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;

@property (weak, nonatomic) IBOutlet UIView *checkInView;
@property (weak, nonatomic) IBOutlet UIView *redeemed;
@property (weak, nonatomic) IBOutlet UIView *favourites;
@property (weak, nonatomic) IBOutlet UIView *scoutView;
@property (weak, nonatomic) IBOutlet UIView *shnerglerView;
@property (weak, nonatomic) IBOutlet UIView *explorerView;

@property (weak, nonatomic) IBOutlet UILabel *explorerLabel;
@property (weak, nonatomic) IBOutlet UILabel *shnerglerLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoutLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalScore;

@end

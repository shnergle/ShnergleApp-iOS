//
//  ProfileViewController.h
//  ShnergleApp
//
//  Created by Harshita Balaga on 03/05/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface ProfileViewController : UIViewController

//- (IBAction)authButtonAction:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *authButton;

//@property (strong, nonatomic) FBProfilePictureView *profilePictureView;
@property (strong, nonatomic) IBOutlet UILabel *lab;

@end
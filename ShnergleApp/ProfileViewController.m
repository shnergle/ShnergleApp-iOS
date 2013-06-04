//
//  ProfileViewController.m
//  ShnergleApp
//
//  Created by Harshita Balaga on 03/05/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "ProfileViewController.h"
#import "AppDelegate.h"
#import "ViewController.h"

@implementation ProfileViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    //FBLoginView* loginview = [[FBLoginView alloc ]init];
    //loginview.delegate = self;
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor blackColor], UITextAttributeTextColor,
      [UIColor clearColor], UITextAttributeTextShadowColor,
      [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset,
      [UIFont fontWithName:@"Roboto" size:14.0], UITextAttributeFont,
      nil]
                                                          forState:UIControlStateNormal];
    
    self.navigationItem.title = @"About you";
    
    UIBarButtonItem *menuButton;
    menuButton = [self createLeftBarButton:@"arrow_west" actionSelector:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = menuButton;
    self.navigationItem.rightBarButtonItem.title = @"Sign out";
    self.navigationItem.rightBarButtonItem.target = self;
    self.navigationItem.rightBarButtonItem.action = @selector(signOut);
    
    AppDelegate *appdelegate = [[UIApplication sharedApplication]delegate];
    self.lab.text = appdelegate.fullName;
}


- (void)populateUserDetails
{
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary<FBGraphUser> *user,
           NSError *error) {
             if (!error) {
                 self.userProfileImage.profileID = user.id;
             }
         }];
    }
}



- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
}

/*- (IBAction)authButtonAction:(id)sender {
 
 AppDelegate *appDelegate =
 [[UIApplication sharedApplication] delegate];
 
 // If the user is authenticated, log out when the button is clicked.
 // If the user is not authenticated, log in when the button is clicked.
 
 [appDelegate closeSession];
 
 // The user has initiated a login, so call the openSession method
 // and show the login UX if necessary.
 //[appDelegate openSessionWithAllowLoginUI:YES];
 
 
 
 }*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIBarButtonItem *)createLeftBarButton:(NSString *)imageName actionSelector:(SEL)actionSelector {
    UIImage *menuButtonImg = [UIImage imageNamed:imageName];
    
    UIButton *menuButtonTmp = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButtonTmp.frame = CGRectMake(280.0, 10.0, 19.0, 16.0);
    [menuButtonTmp setBackgroundImage:menuButtonImg forState:UIControlStateNormal];
    [menuButtonTmp addTarget:self action:actionSelector forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc]initWithCustomView:menuButtonTmp];
    return menuButton;
}

//workaround to get the custom back button to work
- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)signOut {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.session closeAndClearTokenInformation];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end

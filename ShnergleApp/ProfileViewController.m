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
#import "PostRequest.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    //FBLoginView* loginview = [[FBLoginView alloc ]init];
    //loginview.delegate = self;
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:
     @{UITextAttributeTextColor: [UIColor blackColor],
      UITextAttributeTextShadowColor: [UIColor clearColor],
      UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, 0)],
      UITextAttributeFont: [UIFont fontWithName:@"Roboto" size:14.0]}
                                                          forState:UIControlStateNormal];
    
    //self.navigationItem.title = @"About you";
    
    
    UIBarButtonItem *menuButton;
    menuButton = [self createLeftBarButton:@"arrow_west" actionSelector:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = menuButton;
    self.navigationItem.rightBarButtonItem.title = @"Sign out";
    self.navigationItem.rightBarButtonItem.target = self;
    self.navigationItem.rightBarButtonItem.action = @selector(signOut);
    
    AppDelegate *appdelegate = [[UIApplication sharedApplication]delegate];
    self.navigationItem.title = appdelegate.fullName;
    //self.lab.text = appdelegate.fullName;
    //NSLog(@"%@", appdelegate.facebookId);
    self.userProfileImage.profileID = appdelegate.facebookId;
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if (appDelegate.twitter)
        _twitterSwitch.on = YES;
}



- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    //Sketchy! Look out for bugs. this is done to hide the navbar beautifully when navigating back to main page or login page
    [self.navigationController setNavigationBarHidden:YES animated:YES];
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

- (IBAction)twitterSwitchAction:(id)sender {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    id delegateMe = self;
    ProfileViewController *me = self;
    if (_twitterSwitch.on) {
        ACAccountStore *accountStore = [[ACAccountStore alloc] init];
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
            
            ACAccountType *twitterAccountType = [accountStore
                                                 accountTypeWithAccountTypeIdentifier:
                                                 ACAccountTypeIdentifierTwitter];
            [accountStore
             requestAccessToAccountsWithType:twitterAccountType
             options:NULL
             completion:^(BOOL granted, NSError *error) {
                 if (granted) {
                     me.accounts = [accountStore accountsWithAccountType:twitterAccountType];
                     if (me.accounts.count > 0) {
                         if (me.accounts.count > 1) {
                             UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Title" delegate:delegateMe cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:nil];
                             for (int i = 0; i < me.accounts.count; i++)
                                 [popupQuery addButtonWithTitle:[[me.accounts objectAtIndex:i] username]];
                             popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
                             [popupQuery showInView:me.view];
                         } else {
                             NSString *twitter = [[me.accounts lastObject] username];
                             appDelegate.twitter = twitter;
                             NSString *params = [NSString stringWithFormat:@"facebook_id=%@&twitter=%@", appDelegate.facebookId, twitter];
                             if (![[[PostRequest alloc] init] exec:@"users/set" params:params delegate:self callback:@selector(twitterReq:) type:@"string"]) {
                                 [self alertTwitter];
                             }
                         }
                     } else _twitterSwitch.on = NO;
                 } else _twitterSwitch.on = NO;
             }];
        }
    } else {
        appDelegate.twitter = nil;
        NSString *params = [NSString stringWithFormat:@"facebook_id=%@&twitter=", appDelegate.facebookId];
        if (![[[PostRequest alloc] init] exec:@"users/set" params:params delegate:self callback:@selector(twitterReq:) type:@"string"]) {
            [self alertTwitter];
        }
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if (buttonIndex == [actionSheet cancelButtonIndex]) {
        _twitterSwitch.on = NO;
    } else {
        NSString *twitter = [[_accounts objectAtIndex:buttonIndex] username];
        appDelegate.twitter = twitter;
        NSString *params = [NSString stringWithFormat:@"facebook_id=%@&twitter=%@", appDelegate.facebookId, twitter];
        if (![[[PostRequest alloc] init] exec:@"users/set" params:params delegate:self callback:@selector(twitterReq:) type:@"string"]) {
            [self alertTwitter];
        }

    }
}

- (void)twitterReq:(id)response {
    if (![response isEqual:@"true"])
        [self alertTwitter];
}


- (void)alertTwitter {
    _twitterSwitch.on = !_twitterSwitch.on;
    UIActionSheet *alert = [[UIActionSheet alloc] initWithTitle:@"Twitter (de)activation failed!" delegate:nil cancelButtonTitle:@"OK" destructiveButtonTitle:nil otherButtonTitles:nil];
    [alert showInView:[[self view] window]];
}

@end

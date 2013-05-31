//
//  ProfileViewController.m
//  Consumer App
//
//  Created by Harshita Balaga on 03/05/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "ProfileViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"


@interface ProfileViewController () <FBLoginViewDelegate>

//@property (strong, nonatomic) FBProfilePictureView *profilePictureView;
@property (strong, nonatomic) IBOutlet UILabel *lab;


@end

@implementation ProfileViewController

//@synthesize profilePictureView = _profilePictureView;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad
{

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    //FBLoginView* loginview = [[FBLoginView alloc ]init];
    //loginview.delegate = self;
    
    AppDelegate *appdelegate = [[UIApplication sharedApplication]delegate];
    self.lab.text = appdelegate.fullName;
    

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

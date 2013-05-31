//
//  ProfileViewController.m
//  Consumer App
//
//  Created by Harshita Balaga on 03/05/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "ProfileViewController.h"
#import <FacebookSDK/FacebookSDK.h>


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

-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user {
    self.lab.text = [NSString stringWithFormat:@"%@", [user name]];
}


- (void)viewDidLoad
{

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    FBLoginView* loginview = [[FBLoginView alloc ]init];
    loginview.delegate = self;
    //loginview.frame = CGRectOffset(loginview.frame, 20, 50);
    //[self.view addSubview:loginview];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

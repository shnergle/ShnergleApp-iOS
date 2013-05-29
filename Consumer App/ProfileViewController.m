//
//  ProfileViewController.m
//  Consumer App
//
//  Created by Harshita Balaga on 03/05/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "ProfileViewController.h"
#import <FacebookSDK/FacebookSDK.h>


@interface ProfileViewController ()

@property (strong, nonatomic) FBProfilePictureView *profilePictureView;
@property (strong, nonatomic) IBOutlet UILabel *names;


@end

@implementation ProfileViewController

@synthesize profilePictureView = _profilePictureView;
//@synthesize name = _name;

/* - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/


/*-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user{
    
    [FBRequestConnection
     startForMeWithCompletionHandler:^(FBRequestConnection *connection,
                                       id<FBGraphUser> user,
                                       NSError *error)
    {
    NSLog(@"usr_id::%@",user.id);
    NSLog(@"usr_first_name::%@",user.first_name);
    NSLog(@"usr_middle_name::%@",user.middle_name);
    NSLog(@"usr_last_nmae::%@",user.last_name);
    NSLog(@"usr_Username::%@",user.username);
    NSLog(@"usr_b_day::%@",user.birthday);
    }
   
    ];
    [self.view addSubview:loginView];
}
*/


- (void)viewDidLoad
{
    [super viewDidLoad];
    [FBRequestConnection
     startForMeWithCompletionHandler:^(FBRequestConnection *connection,
                                       id<FBGraphUser> user,
                                       NSError *error)
     {
         NSLog(@"usr_id::%@",user.id);
         NSLog(@"usr_first_name::%@",user.first_name);
         NSLog(@"usr_middle_name::%@",user.middle_name);
         NSLog(@"usr_last_nmae::%@",user.last_name);
         NSLog(@"usr_Username::%@",user.username);
         NSLog(@"usr_b_day::%@",user.birthday);
     }
     
     ];
    //[self.view addSubview:loginView];
    
    /*
    // Do any additional setup after loading the view from its nib.
    
    // Initialize the profile picture
    self.profilePictureView = [[FBProfilePictureView alloc] init];
    // Set the size
    self.profilePictureView.frame = CGRectMake(0.0, 0.0, 75.0, 75.0);
    [FBRequestConnection
         startForMeWithCompletionHandler:^(FBRequestConnection *connection,
                                           id<FBGraphUser> user,
                                           NSError *error)
         {
             
                 NSString *userInfo = @"";
                 
                 // Example: typed access (name)
                 // - no special permissions required
                 userInfo = [userInfo
                             stringByAppendingString:
                             [NSString stringWithFormat:@"Name: %@\n\n",
                              user.name]];
             
                 self.names.text = userInfo;
             
             // Show the profile picture for a user
             //self.profilePictureView = user.
             //self.name.text = userInfo;
             // Add the profile picture view to the main view
             //[self.view addSubview:self.profilePictureView];
             //[self.view addSubview:self.names];
             
         } 
     ];
*/

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

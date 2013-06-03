//
//  LoginScreenController.m
//  ShnergleApp
//
//  Created by Harshita Balaga on 26/04/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "LoginScreenController.h"
#import "AppDelegate.h"
#import "ViewController.h"
#import "PostRequest.h"

@implementation LoginScreenController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {



    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [self updateView];

    //[self colouriseNavBar];
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    if (!appDelegate.session.isOpen) {
        // create a fresh session object
        appDelegate.session = [[FBSession alloc] initWithPermissions:[NSArray arrayWithObjects:@"email", @"user_birthday", nil]];

        // if we don't have a cached token, a call to open here would cause UX for login to
        // occur; we don't want that to happen unless the user clicks the login button, and so
        // we check here to make sure we have a token before calling open
        if (appDelegate.session.state == FBSessionStateCreatedTokenLoaded) {
            // even though we had a cached token, we need to login to make the session usable
            [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                             FBSessionState status,
                                                             NSError *error) {
                 // we recurse here, in order to update buttons and labels
                 [self updateView];



             }];


        }
    }




}

// FBSample logic
// main helper method to update the UI to reflect the current state of the session.
- (void)updateView {
    // get the app delegate, so that we can reference the session property
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    UIImage *image = [UIImage imageNamed: @"fb-login-button.png"];
    UIImage *image2 = [UIImage imageNamed: @"fbloginview_logout.png"];
    if (appDelegate.session.isOpen) {
        // valid account UI is shown whenever the session is open
        self.buttonLoginLogout.enabled = NO;
        [self.buttonLoginLogout setImage:image2 forState:UIControlStateNormal];


        //login on server
        [[[FBRequest alloc] initWithSession:appDelegate.session graphPath:@"me"] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary<FBGraphUser> *user,
           NSError *error) {
             if (!error) {
                 appDelegate.fullName = [NSString stringWithFormat:@"%@ %@", user.first_name, user.last_name];
                 appDelegate.facebookId = user.id;
                 appDelegate.email = [user objectForKey:@"email"];
                 NSMutableString *params = [[NSMutableString alloc] initWithString:@"facebook_id="];
                 [params appendString:user.id];
                 [params appendString:@"&facebook="];
                 [params appendString:user.username];
                 [params appendString:@"&forename="];
                 [params appendString:user.first_name];
                 [params appendString:@"&surname="];
                 [params appendString:user.last_name];
                 [params appendString:@"&email="];
                 [params appendString:[user objectForKey:@"email"]];
                 [params appendString:@"&gender="];
                 [params appendString:[[user objectForKey:@"gender"] substringToIndex:1]];
                 [params appendString:@"&country="];
                 [params appendString:[[[user objectForKey:@"locale"] substringFromIndex:3] lowercaseString]];
                 [params appendString:@"&language="];
                 [params appendString:[user objectForKey:@"locale"]];
                 [params appendString:@"&birth_day="];
                 [params appendString:[[user objectForKey:@"birthday"] substringWithRange:NSMakeRange(3, 2)]];
                 [params appendString:@"&birth_month="];
                 [params appendString:[[user objectForKey:@"birthday"] substringToIndex:2]];
                 [params appendString:@"&birth_year="];
                 [params appendString:[[user objectForKey:@"birthday"] substringFromIndex:6]];
                 NSDate* now = [NSDate date];
                 NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                 [dateFormatter setDateFormat:@"MM/dd/yyyy"];
                 NSDate* birthday = [dateFormatter dateFromString:[user objectForKey:@"birthday"]];
                 NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                                    components:NSYearCalendarUnit
                                                    fromDate:birthday
                                                    toDate:now
                                                    options:0];
                 NSInteger age = [ageComponents year];
                 [params appendString:@"&age="];
                 [params appendString:[NSString stringWithFormat:@"%d", age]];
                 
                 [[[PostRequest alloc] init] exec:@"users/set" params:params delegate:self callback:@selector(postResponse:)];

                 UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
                 ViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"AroundMeSlidingViewController"];
                 self.buttonLoginLogout.enabled = YES;
                 [self.navigationController pushViewController:vc animated:YES];
             } else {
                 NSLog(@"FUCKING FACEBOOK");
                 self.buttonLoginLogout.enabled = YES;
             }
         }];

        /*[self.textNoteOrLink setText:[NSString stringWithFormat:@"https://graph.facebook.com/me/friends?access_token=%@",
           appDelegate.session.accessTokenData.accessToken]];*/
    } else {
        // login-needed account UI is shown whenever the session is closed
        [self.buttonLoginLogout setImage:image forState:UIControlStateNormal];
        //[self.textNoteOrLink setText:@"Login to create a link to fetch account data"];
    }

}

- (void)postResponse:(NSString *)response {
    NSLog(@"actual response: %@", response);
}

// FBSample logic
// handler for button click, logs sessions in or out
- (IBAction)buttonClickHandler:(id)sender {
    // get the app delegate so that we can access the session property
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];

    // this button's job is to flip-flop the session from open to closed
    if (appDelegate.session.isOpen) {
        // if a user logs out explicitly, we delete any cached token information, and next
        // time they run the applicaiton they will be presented with log in UX again; most
        // users will simply close the app or switch away, without logging out; this will
        // cause the implicit cached-token login to occur on next launch of the application
        [appDelegate.session closeAndClearTokenInformation];

    } else {
        if (appDelegate.session.state != FBSessionStateCreated) {
            // Create a new, logged out session.
            appDelegate.session = [[FBSession alloc] init];
        }

        // if the session isn't open, let's open it now and present the login UX to the user
        [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                         FBSessionState status,
                                                         NSError *error) {
             // and here we make sure to update our UX according to the new session state
             [self updateView];
         }];
    }
}

#pragma mark Template generated code

- (void)viewDidUnload
{
    self.buttonLoginLogout = nil;
    //self.textNoteOrLink = nil;

    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
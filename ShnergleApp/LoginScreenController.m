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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [[self navigationController] setNavigationBarHidden:TRUE];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.buttonLoginLogout setBackgroundImage:[UIImage imageNamed:@"login-button-small.png"] forState:UIControlStateNormal];
    [self.buttonLoginLogout setBackgroundImage:[UIImage imageNamed:@"login-button-small-pressed.png"] forState:UIControlStateHighlighted];
    
    [self updateView];
    
    //HideNavBar
    [[self navigationController] setNavigationBarHidden:TRUE];
    //[self colouriseNavBar];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if (!appDelegate.session.isOpen) {
        self.buttonLoginLogout.hidden = YES;
        // create a fresh session object
        appDelegate.session = [[FBSession alloc] initWithAppID:nil permissions:@[@"email", @"user_birthday"] urlSchemeSuffix:nil tokenCacheStrategy:nil];
        
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
        } else {
            self.buttonLoginLogout.hidden = NO;
        }
    }
}

// FBSample logic
// main helper method to update the UI to reflect the current state of the session.
- (void)updateView {
    // get the app delegate, so that we can reference the session property
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    //UIImage *image = [UIImage imageNamed: @"fb-login-button.png"];
    //UIImage *image2 = [UIImage imageNamed: @"fbloginview_logout.png"];
    if (appDelegate.session.isOpen) {
        // valid account UI is shown whenever the session is open
        self.buttonLoginLogout.hidden = YES;
        //[self.buttonLoginLogout setImage:image2 forState:UIControlStateNormal];
        
        
        //login on server
        [[[FBRequest alloc] initWithSession:appDelegate.session graphPath:@"me"] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary<FBGraphUser> *user,
           NSError *error) {
             if (!error) {
                 appDelegate.fullName = [NSString stringWithFormat:@"%@ %@", user.first_name, user.last_name];
                 appDelegate.facebookId = user.id;
                 appDelegate.email = user[@"email"];
                 NSMutableString *params = [[NSMutableString alloc] initWithString:@"facebook_id="];
                 [params appendString:user.id];
                 [params appendString:@"&facebook="];
                 [params appendString:user.username];
                 [params appendString:@"&forename="];
                 [params appendString:user.first_name];
                 [params appendString:@"&surname="];
                 [params appendString:user.last_name];
                 [params appendString:@"&email="];
                 [params appendString:user[@"email"]];
                 [params appendString:@"&gender="];
                 [params appendString:[user[@"gender"] substringToIndex:1]];
                 [params appendString:@"&country="];
                 [params appendString:[[user[@"locale"] substringFromIndex:3] lowercaseString]];
                 [params appendString:@"&language="];
                 [params appendString:user[@"locale"]];
                 [params appendString:@"&birth_day="];
                 [params appendString:[user[@"birthday"] substringWithRange:NSMakeRange(3, 2)]];
                 [params appendString:@"&birth_month="];
                 [params appendString:[user[@"birthday"] substringToIndex:2]];
                 [params appendString:@"&birth_year="];
                 [params appendString:[user[@"birthday"] substringFromIndex:6]];
                 NSDate *now = [NSDate date];
                 NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                 [dateFormatter setDateFormat:@"MM/dd/yyyy"];
                 NSDate *birthday = [dateFormatter dateFromString:user[@"birthday"]];
                 NSDateComponents *ageComponents = [[NSCalendar currentCalendar]
                                                    components:NSYearCalendarUnit
                                                    fromDate:birthday
                                                    toDate:now
                                                    options:0];
                 NSInteger age = [ageComponents year];
                 [params appendString:@"&age="];
                 [params appendString:[NSString stringWithFormat:@"%d", age]];
                 
                 if (![[[PostRequest alloc] init] exec:@"users/set" params:params delegate:self callback:@selector(postResponse:) type:@"string"])
                     [self alert];
                 
             } else {
                 
                 self.buttonLoginLogout.hidden = NO;
                 [self alert];
             }
         }];
        
        /*[self.textNoteOrLink setText:[NSString stringWithFormat:@"https://graph.facebook.com/me/friends?access_token=%@",
         appDelegate.session.accessTokenData.accessToken]];*/
    } else {
        self.buttonLoginLogout.hidden = NO;
        // login-needed account UI is shown whenever the session is closed
        //[self.buttonLoginLogout setImage:image forState:UIControlStateNormal];
        //[self.textNoteOrLink setText:@"Login to create a link to fetch account data"];
    }
}

- (void)postResponse:(id)response {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if ([response isEqual:@"true"]) {
        NSString *params = [NSString stringWithFormat:@"facebook_id=%@", appDelegate.facebookId];
        if (![[[PostRequest alloc] init] exec:@"users/get" params:params delegate:self callback:@selector(getResponse:)])
            [self alert];
    } else {
        [self alert];
    }
}

- (void)getResponse:(id)response {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if (response) {
        if (![((NSDictionary *)response)[@"twitter"] isEqual:@""])
            appDelegate.twitter = ((NSDictionary *)response)[@"twitter"];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        ViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"AroundMeSlidingViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [self alert];
    }
}

- (IBAction)buttonClickHandler:(id)sender {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    if (appDelegate.session.state != FBSessionStateCreated) appDelegate.session = [[FBSession alloc] initWithAppID:nil permissions:@[@"email", @"user_birthday"] urlSchemeSuffix:nil tokenCacheStrategy:nil];    
    [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                     FBSessionState status,
                                                     NSError *error) {
        // and here we make sure to update our UX according to the new session state
        [self updateView];
    }];
}

- (void)viewDidUnload {
    self.buttonLoginLogout = nil;
    //self.textNoteOrLink = nil;
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alert {
    UIActionSheet *alert = [[UIActionSheet alloc] initWithTitle:@"Connection failed!" delegate:nil cancelButtonTitle:@"OK" destructiveButtonTitle:nil otherButtonTitles:nil];
    [alert showInView:[[self view] window]];
}

@end

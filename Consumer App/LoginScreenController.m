//
//  LoginScreenController.m
//  Consumer App
//
//  Created by Harshita Balaga on 26/04/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "LoginScreenController.h"
#import "AppDelegate.h"
#import "ViewController.h"
//#import "AppDelegate.m"

@interface LoginScreenController ()

@property (strong, nonatomic) IBOutlet UIButton *buttonLoginLogout;
//@property (strong, nonatomic) IBOutlet UITextView *textNoteOrLink;

@property (strong, nonatomic) NSMutableData *response;

- (IBAction)buttonClickHandler:(id)sender;
- (void)updateView;

@end

//@class ViewController;

@implementation LoginScreenController

@synthesize buttonLoginLogout = _buttonLoginLogout;

@synthesize response = _response;

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
        appDelegate.session = [[FBSession alloc] init];
        
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
        
       [self.buttonLoginLogout setImage:image2 forState:UIControlStateNormal];
        
        
        //login on server
        NSMutableString *params = [[NSMutableString alloc] initWithString:@"app_secret=FCuf65iuOUDCjlbiyyer678Coutyc64v655478VGvgh76&"];
        

            [[[FBRequest alloc] initWithSession:appDelegate.session graphPath:@"me"] startWithCompletionHandler:
             ^(FBRequestConnection *connection,
               NSDictionary<FBGraphUser> *user,
               NSError *error) {
                 if (!error) {
                     NSMutableString *fullName = [[NSMutableString alloc] initWithString:user.first_name];
                     [fullName appendString:@" "];
                     [fullName appendString:user.last_name];
                     appDelegate.fullName = fullName;
                     [params appendString:@"facebook_id="];
                     [params appendString:user.id];
                     [params appendString:@"&facebook="];
                     [params appendString:user.username];
                     [params appendString:@"&forename="];
                     [params appendString:user.first_name];
                     [params appendString:@"&surname="];
                     [params appendString:user.last_name];
                     NSMutableString *urlString;
                     urlString=[[NSMutableString alloc] initWithString:@"http://shnergle-api.azurewebsites.net/users/set"];
                     NSURL *url;
                     url=[[NSURL alloc] initWithString:urlString];
                     
                     NSMutableURLRequest *urlRequest=[NSMutableURLRequest requestWithURL:url];
                     
                     [urlRequest setHTTPMethod:@"POST"];
                     [urlRequest setHTTPBody:[params dataUsingEncoding:NSISOLatin1StringEncoding]];
                     
                     _response = [[NSMutableData alloc] init];
                     
                     NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
                     
                     UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
                     ViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"AroundMeSlidingViewController"];
                     
                     [self.navigationController pushViewController:vc animated:YES];
                     
                     if (!connection)
                     {
                         NSLog(@"Failed to submit request");
                     }
                     else
                     {
                         NSLog(@"--------- Request submitted ---------");
                         NSLog(@"connection: %@ method: %@, encoded body: %@, body: %@", connection, [urlRequest HTTPMethod], [urlRequest HTTPBody], params);
                     }
                 } else {
                     NSLog(@"FUCKING FACEBOOK");
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

- (void)connection:(NSURLConnection *) connection didReceiveData:(NSData *)data {
    [_response appendData:data];
}

-(void)connectionDidFinishLoading: (NSURLConnection *)connection {
    NSString *responseString = [[NSString alloc] initWithData:_response encoding:NSUTF8StringEncoding];
    NSLog(@"actual response: %@", responseString);
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

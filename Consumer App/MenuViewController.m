//
//  MenuViewController.m
//  Consumer App
//
//  Created by Stian Johansen on 11/05/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "MenuViewController.h"
#import "AppDelegate.h"
#import "SearchBarView.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

@synthesize nameLabel;
@synthesize searchBar;
@synthesize bar = _bar;
@synthesize response = _response;

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
    
    //load search bar
    NSArray *bundle = [[NSBundle mainBundle] loadNibNamed:@"SearchBar" owner:self options:nil];
    SearchBarView *blah;
    for (id object in bundle) {
        if ([object isKindOfClass:[SearchBarView class]])
            blah = (SearchBarView *)object;
    }
    assert(blah != nil && "searchBarView can't be nil");
    [self.view addSubview: blah];
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    
    nameLabel.font = [UIFont fontWithName:@"Roboto" size:nameLabel.font.pointSize];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.text = appDelegate.fullName;
    
}

- (void)connection:(NSURLConnection *) connection didReceiveData:(NSData *)data {
    [_response appendData:data];
}

-(void)connectionDidFinishLoading: (NSURLConnection *)connection {
    NSString *responseString = [[NSString alloc] initWithData:_response encoding:NSUTF8StringEncoding];
    NSLog(@"search response: %@", responseString);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)tapProfile:(id)sender {
    NSLog(@"Profle tapped");
}

- (IBAction)something:(id)sender {
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    NSMutableString *params = [[NSMutableString alloc] initWithString:@"app_secret=FCuf65iuOUDCjlbiyyer678Coutyc64v655478VGvgh76&term="];
    [params appendString:_bar.text];
    [params appendString:@"&facebook_id="];
    [params appendString:appDelegate.facebook_id];
    NSMutableString *urlString;
    urlString=[[NSMutableString alloc] initWithString:@"http://shnergle-api.azurewebsites.net/user_searches/set"];
    NSURL *url;
    url=[[NSURL alloc] initWithString:urlString];
    
    NSMutableURLRequest *urlRequest=[NSMutableURLRequest requestWithURL:url];
    
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSISOLatin1StringEncoding]];
    _response = [[NSMutableData alloc] init];
        
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    
}
@end

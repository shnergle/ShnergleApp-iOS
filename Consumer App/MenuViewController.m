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
//@synthesize tableData;

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
    
    tableData = [[NSArray alloc] initWithObjects:@"Around me", @"Favourites", @"Promotions", @"Quiet", @"Trending", nil];
    
#pragma mark - Tableview Data Source Methods
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)tapProfile:(id)sender {
    NSLog(@"Profle tapped");
}
@end

//
//  MenuViewController.m
//  ShnergleApp
//
//  Created by Stian Johansen on 11/05/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "MenuViewController.h"
#import "AppDelegate.h"
#import "SearchBarView.h"
#import "PostRequest.h"

@implementation MenuViewController

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
    
    //load search bar
    NSArray *bundle = [[NSBundle mainBundle] loadNibNamed:@"SearchBar" owner:self options:nil];
    SearchBarView *blah;
    for (id object in bundle) {
        if ([object isKindOfClass:[SearchBarView class]]) blah = (SearchBarView *)object;
    }
    assert(blah != nil && "searchBarView can't be nil");
    [self.view addSubview:blah];
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    
    _nameLabel.font = [UIFont fontWithName:@"Roboto" size:_nameLabel.font.pointSize];
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.text = appDelegate.fullName;
    
    _tableData = @[@"Around me", @"Favourites", @"Promotions", @"Quiet", @"Trending"];
    
}

- (void)postResponse:(NSString *)response {
    NSLog(@"search response: %@", response);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_tableData count];
}*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    if (indexPath.section != 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"MyCell%d", indexPath.item]];
    }
    
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell"];
    }
    
    AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
    if (indexPath.section == 0) {
        cell.textLabel.text = appdelegate.fullName;
    }
    else
    {
    cell.textLabel.text = _tableData[indexPath.row];
    }
    
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont fontWithName:@"Roboto" size:20.0];

    if (indexPath.section == 0) cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profileicon.png"]];
    
    return cell;
}

- (IBAction)tapProfile:(id)sender {
    NSLog(@"Profle tapped");
}

- (IBAction)searchExited:(id)sender {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSString *params = [NSString stringWithFormat:@"term=%@&facebook_id=%@", _bar.text, appDelegate.facebookId];
    [[[PostRequest alloc] init] exec:@"user_searches/set" params:params delegate:self callback:@selector(postResponse:)];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else
    {
        return 5;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

/*-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return @[@"Profile", @"Explore"];
}*/

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    return (@[@"Profile", @"Explore"])[section];
    
    //[section setBackgroundColor:[UIColor blackColor]];
}


/*- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *section = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 22)] autorelease];
    
    return section;
}*/


@end

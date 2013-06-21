//
//  VenueCategoryViewController.m
//  ShnergleApp
//
//  Created by Stian Johansen on 10/06/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "VenueCategoryViewController.h"
#import "AppDelegate.h"
#import "PostRequest.h"

@implementation VenueCategoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Add Place";
    categories = [[NSMutableArray alloc] init];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSString *params = [NSString stringWithFormat:@"facebook_id=%@", appDelegate.facebookId];
    [[[PostRequest alloc]init]exec:@"categories/get" params:params delegate:self callback:@selector(postResponse:)];
    
}

- (void)postResponse:(id)response {
    //NSLog(@"search response: %@", response);
    if([response isKindOfClass:[NSArray class]]){
        //_searchResults = [[NSMutableArray alloc]initWithArray:response];
        for(id obj in response){
            if([obj count] > 1)
                [categories addObject:obj[1]];
        }
    }
    
    [self.categoryTableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = categories[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"location_icon.png"];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.addVenueType = categories[indexPath.row];
    [self goBack];
}

@end

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
#import <Toast+UIView.h>

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
    [self.view makeToastActivity];
    self.navigationItem.title = @"Add Place";
    categories = [[NSMutableArray alloc] init];

    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSString *params = [NSString stringWithFormat:@"facebook_id=%@", appDelegate.facebookId];
    [[[PostRequest alloc]init]exec:@"categories/get" params:params delegate:self callback:@selector(postResponse:)];
}

- (void)postResponse:(id)response {
    //NSLog(@"search response: %@", response);
    if ([response isKindOfClass:[NSArray class]]) {
        //_searchResults = [[NSMutableArray alloc]initWithArray:response];
        for (id obj in response) {
            if ([obj count] > 1) [categories addObject:obj];
        }
    }

    [self.categoryTableView reloadData];
    [self.view hideToastActivity];
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
    cell.textLabel.text = categories[indexPath.row][1];
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", categories[indexPath.row][0]]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.addVenueType = categories[indexPath.row][1];
    [self goBack];
}

@end

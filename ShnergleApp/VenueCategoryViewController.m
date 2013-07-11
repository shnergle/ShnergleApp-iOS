//
//  VenueCategoryViewController.m
//  ShnergleApp
//
//  Created by Stian Johansen on 10/06/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "VenueCategoryViewController.h"
#import "PostRequest.h"
#import <Toast+UIView.h>

@implementation VenueCategoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view makeToastActivity];
    self.navigationItem.title = @"Add Place";
    categories = [[NSMutableArray alloc] init];

    [[[PostRequest alloc]init]exec:@"categories/get" params:@"" delegate:self callback:@selector(postResponse:)];
}

- (void)postResponse:(id)response {
    if ([response isKindOfClass:[NSArray class]]) {
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
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", categories[indexPath.row][@"id"]]];
    UILabel *textView = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 270, cell.bounds.size.height)];
    textView.text = categories[indexPath.row][@"type"];
    textView.font = [UIFont fontWithName:cell.textLabel.font.fontName size:20];
    textView.backgroundColor = tableView.backgroundColor;
    [cell addSubview:textView];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    appDelegate.addVenueType = categories[indexPath.row][@"type"];
    appDelegate.addVenueTypeId =  [NSString stringWithFormat:@"%@", categories[indexPath.row][@"id"]];
    [self goBack];
}

@end

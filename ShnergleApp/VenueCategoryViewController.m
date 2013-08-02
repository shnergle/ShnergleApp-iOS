//
//  VenueCategoryViewController.m
//  ShnergleApp
//
//  Created by Stian Johansen on 10/06/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "VenueCategoryViewController.h"
#import "PostRequest.h"
#import <Toast/Toast+UIView.h>

@implementation VenueCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view makeToastActivity];
    self.navigationItem.title = @"+ Add Place";
    categories = [NSMutableArray array];

    [[[PostRequest alloc] init] exec:@"venue_categories/get" params:@"" delegate:self callback:@selector(postResponse:)];
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.imageView.image = [UIImage imageNamed:[categories[indexPath.row][@"id"] stringValue]];
    UILabel *textView = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 270, cell.bounds.size.height)];
    textView.text = categories[indexPath.row][@"type"];
    textView.font = [UIFont fontWithName:cell.textLabel.font.fontName size:20];
    textView.backgroundColor = tableView.backgroundColor;
    [cell addSubview:textView];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    appDelegate.addVenueType = categories[indexPath.row][@"type"];
    appDelegate.addVenueTypeId = [categories[indexPath.row][@"id"] stringValue];
    [self goBack];
}

@end

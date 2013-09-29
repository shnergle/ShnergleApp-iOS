//
//  FindStaffViewController.m
//  ShnergleApp
//
//  Created by Adam Hani Schakaki on 22/07/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "FindStaffViewController.h"
#import <Toast/Toast+UIView.h>
#import "Request.h"
#import "StaffEditViewController.h"

@implementation FindStaffViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = @"Add Staff";
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [results count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ASRCell"];
    FBProfilePictureView *img = [[FBProfilePictureView alloc] initWithFrame:CGRectMake(5, 0, 44, 44)];
    img.profileID = results[indexPath.row][@"facebook_id"];
    [cell addSubview:img];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(54, 0, cell.bounds.size.width - 54, cell.bounds.size.height)];
    label.text = [NSString stringWithFormat:@"%@ %@", results[indexPath.row][@"forename"], results[indexPath.row][@"surname"]];

    [cell addSubview:label];
    return cell;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.view makeToastActivity];
    [Request post:@"users/get" params:@{@"term": searchBar.text} callback:^(id response) {
        results = response;
        [self.resultsView reloadData];
        [self.view hideToastActivity];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isAlreadyInStaffList:results[indexPath.row][@"id"]]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [self.view makeToastActivity];

    NSDictionary *params = @{@"venue_id": appDelegate.activeVenue[@"id"],
                             @"staff_user_id": results[indexPath.row][@"id"],
                             @"manager": @"false",
                             @"promo_perm": @"false"};
    [Request post:@"venue_staff/set" params:params callback:^(id response) {
        if (response) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        [self.view hideToastActivity];
    }];
}

- (BOOL)isAlreadyInStaffList:(id)user_id {
    for (NSDictionary *staff in appDelegate.staff[@"managers"]) {
        if ([staff[@"user_id"] isEqual:user_id]) {
            return YES;
        }
    }
    for (NSDictionary *staff in appDelegate.staff[@"staff"]) {
        if ([staff[@"user_id"] isEqual:user_id]) {
            return YES;
        }
    }
    return NO;
}

@end

//
//  FindStaffViewController.m
//  ShnergleApp
//
//  Created by Adam Hani Schakaki on 22/07/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "FindStaffViewController.h"
#import <Toast/Toast+UIView.h>
#import "PostRequest.h"
#import "StaffEditViewController.h"

@implementation FindStaffViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.title = @"Add Staff";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [results count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ASRCell"];
    FBProfilePictureView *img = [[FBProfilePictureView alloc]initWithFrame:CGRectMake(5, 0, 44, 44)];
    img.profileID = results[indexPath.row][@"facebook_id"];
    [cell addSubview:img];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(54, 0, cell.bounds.size.width - 54, cell.bounds.size.height)];
    label.text = [NSString stringWithFormat:@"%@ %@", results[indexPath.row][@"forename"], results[indexPath.row][@"surname"]];

    [cell addSubview:label];
    return cell;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.view makeToastActivity];
    [[[PostRequest alloc]init] exec:@"users/get" params:[NSString stringWithFormat:@"term=%@", searchBar.text] delegate:self callback:@selector(didFinishSearching:)];
}

- (void)didFinishSearching:(NSArray *)response {
    results = response;
    [self.resultsView reloadData];
    [self.view hideToastActivity];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isAlreadyInStaffList:results[indexPath.row][@"id"]]) {
        [self goBack];
        return;
    }
    [self.view makeToastActivity];
    NSString *params = [NSString stringWithFormat:@"venue_id=%@&staff_user_id=%@&manager=%@&promo_perm=%@", [appDelegate.activeVenue[@"id"] stringValue], [results[indexPath.row][@"id"] stringValue], @"false", @"false"];
    [[[PostRequest alloc] init] exec:@"venue_staff/set" params:params delegate:self callback:@selector(didFinishAddingStaff:) type:@"string"];
}

- (BOOL)isAlreadyInStaffList:(id)user_id {
    for (int i = 0; i < [appDelegate.staff[@"managers"] count]; i++) {
        if ([appDelegate.staff[@"managers"][i][@"user_id"] isEqual:user_id]) {
            return YES;
        }
    }
    for (int i = 0; i < [appDelegate.staff[@"staff"] count]; i++) {
        if ([appDelegate.staff[@"staff"][i][@"user_id"] isEqual:user_id]) {
            return YES;
        }
    }
    return NO;
}

- (void)didFinishAddingStaff:(NSString *)response {
    if ([@"true" isEqualToString : response]) {
        [self goBack];
    }
    [self.view hideToastActivity];
}

@end

//
//  StaffViewController.m
//  ShnergleApp
//
//  Created by Adam Hani Schakaki on 12/06/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "StaffViewController.h"
#import "Request.h"
#import <Toast/Toast+UIView.h>
#import "StaffEditViewController.h"

@implementation StaffViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = @"Staff";
    [self setRightBarButton:@"Add" actionSelector:@selector(addStaff:)];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.view makeToastActivity];
    NSDictionary *params = @{@"venue_id": appDelegate.activeVenue[@"id"]};
    [Request post:@"venue_staff/get" params:params callback:^(id response) {
        appDelegate.staff = response;
        [self.collectionView reloadData];
        [self.view hideToastActivity];
    }];
}

- (void)addStaff:(id)sender {
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FindStaffViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    NSInteger number;
    NSString *type;
    if (indexPath.item >= [appDelegate.staff[@"managers"] count]) {
        number = indexPath.item - [appDelegate.staff[@"managers"] count];
        type = @"staff";
        ((UILabel *)[cell viewWithTag:2]).text = [NSString stringWithFormat:@"Staff - Promotions %@", ([appDelegate.staff[type][number][@"promo_perm"] integerValue] == 1 ? @"enabled" : @"disabled")];
    } else {
        number = indexPath.item;
        type = @"managers";
        ((UILabel *)[cell viewWithTag:2]).text = @"Manager";
    }
    ((UILabel *)[cell viewWithTag:1]).text = appDelegate.staff[type][number][@"name"];
    ((FBProfilePictureView *)[cell viewWithTag:3]).profileID = [NSString stringWithFormat:@"%@", appDelegate.staff[type][number][@"facebook_id"]];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [appDelegate.staff[@"staff"] count] + [appDelegate.staff[@"managers"] count];
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    selectedStaffMember = indexPath.row;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    selectedStaffMember = indexPath.row;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSInteger number;
    NSString *type;
    if (selectedStaffMember >= [appDelegate.staff[@"managers"] count]) {
        number = selectedStaffMember - [appDelegate.staff[@"managers"] count];
        type = @"staff";
        appDelegate.staffType = @"Staff";
    } else {
        number = selectedStaffMember;
        type = @"managers";
        appDelegate.staffType = @"Manager";
    }
    [((StaffEditViewController *)[segue destinationViewController])setStaffMember : appDelegate.staff[type][number]];
}

@end

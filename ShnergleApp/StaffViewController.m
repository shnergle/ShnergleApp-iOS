//
//  StaffViewController.m
//  ShnergleApp
//
//  Created by Adam Hani Schakaki on 12/06/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "StaffViewController.h"
#import "PostRequest.h"
#import <Toast/Toast+UIView.h>

@implementation StaffViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.title = @"Staff";
    [self.view makeToastActivity];
    NSMutableString *params = [[NSMutableString alloc]initWithString:@"venue_id="];
    [params appendString:[appDelegate.activeVenue[@"id"] stringValue]];
    [[[PostRequest alloc] init] exec:@"venue_staff/get" params:params delegate:self callback:@selector(didFinishDownloadingStaff:)];
}

- (void)didFinishDownloadingStaff:(id)response {
    appDelegate.staff = response;
    [self.collectionView reloadData];
    [self.view hideToastActivity];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    int number;
    NSString *type;
    if (indexPath.item >= [appDelegate.staff[@"managers"] count]) {
        number = indexPath.item - [appDelegate.staff[@"managers"] count];
        type = @"staff";
        ((UILabel *) [cell viewWithTag:2]).text = [NSString stringWithFormat:@"Staff - Promotions %@", (appDelegate.staff[type][number][@"promo_perm"] ? @"enabled" : @"disabled")];
    } else {
        number = indexPath.item;
        type = @"managers";
        ((UILabel *) [cell viewWithTag:2]).text = @"Manager";
    }
    ((UILabel *) [cell viewWithTag:1]).text = appDelegate.staff[type][number][@"name"];
    ((FBProfilePictureView *) [cell viewWithTag:3]).profileID = [NSString stringWithFormat:@"%@", appDelegate.staff[type][number][@"facebook_id"]];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [appDelegate.staff[@"staff"] count] + [appDelegate.staff[@"managers"] count];
}

@end

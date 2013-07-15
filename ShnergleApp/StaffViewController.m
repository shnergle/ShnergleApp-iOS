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
    return [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [appDelegate.staff[@"staff"] count] + [appDelegate.staff[@"managers"] count];
}

@end

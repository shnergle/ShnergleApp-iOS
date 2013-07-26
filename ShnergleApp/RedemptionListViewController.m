//
//  RedemptionListViewController.m
//  ShnergleApp
//
//  Created by Adam Hani Schakaki on 24/07/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "RedemptionListViewController.h"
#import <Toast/Toast+UIView.h>
#import <NSDate+TimeAgo/NSDate+TimeAgo.h>
#import "PostRequest.h"

@implementation RedemptionListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.title = @"Redeemed";
    [self.view makeToastActivity];
    [[[PostRequest alloc] init] exec:@"promotion_redemptions/get" params:[[NSMutableString alloc] init] delegate:self callback:@selector(didFinishDownloadingPosts:)];
}

- (void)didFinishDownloadingPosts:(id)response {
    promos = response;
    [self.collectionView reloadData];
    [self.view hideToastActivity];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    ((UILabel *)[cell viewWithTag:1]).text = promos[indexPath.item][@"name"];
    ((UILabel *)[cell viewWithTag:2]).text = [self getDateFromUnixFormat:promos[indexPath.item][@"time"]];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [promos count];
}

- (NSString *)getDateFromUnixFormat:(id)unixFormat {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[unixFormat intValue]];
    return [date timeAgoWithLimit:86400 dateFormat:NSDateFormatterShortStyle andTimeFormat:NSDateFormatterShortStyle];
}

@end
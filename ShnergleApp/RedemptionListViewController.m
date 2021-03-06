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
#import "Request.h"

@implementation RedemptionListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view makeToastActivity];
    [Request post:@"promotion_redemptions/get" params:nil callback:^(id response) {
        promos = response;
        [self.collectionView reloadData];
        [self.view hideToastActivity];
    }];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    ((UILabel *)[cell viewWithTag:1]).text = promos[indexPath.item][@"description"];
    ((UILabel *)[cell viewWithTag:2]).text = promos[indexPath.item][@"passcode"];
    ((UILabel *)[cell viewWithTag:3]).text = promos[indexPath.item][@"name"];
    ((UILabel *)[cell viewWithTag:4]).text = [self getDateFromUnixFormat:promos[indexPath.item][@"time"]];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [promos count];
}

- (NSString *)getDateFromUnixFormat:(id)unixFormat {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[unixFormat integerValue]];
    if ([unixFormat integerValue] < [[NSDate date] timeIntervalSince1970] - 86400 * 8) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterShortStyle;
        dateFormatter.timeStyle = NSDateFormatterShortStyle;
        return [dateFormatter stringFromDate:date];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"ccc H:mm";
    return [date timeAgoWithLimit:86400 dateFormatter:dateFormatter];
}

@end

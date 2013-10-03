//
//  CheckInListViewController.m
//  ShnergleApp
//
//  Created by Adam Hani Schakaki on 18/07/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "CheckInListViewController.h"
#import <Toast/Toast+UIView.h>
#import "Request.h"
#import <NSDate+TimeAgo/NSDate+TimeAgo.h>

@implementation CheckInListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view makeToastActivity];
    [Request post:@"posts/get" params:nil callback:^(id response) {
        @synchronized(self) {
            posts = response;
            [self.collectionView reloadData];
            [self.view hideToastActivity];
        }
    }];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    ((UILabel *)[cell viewWithTag:1]).text = posts[indexPath.item][@"name"];
    ((UILabel *)[cell viewWithTag:2]).text = [self getDateFromUnixFormat:posts[indexPath.item][@"time"]];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [posts count];
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

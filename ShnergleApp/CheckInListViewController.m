//
//  CheckInListViewController.m
//  ShnergleApp
//
//  Created by Adam Hani Schakaki on 18/07/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "CheckInListViewController.h"
#import <Toast/Toast+UIView.h>
#import "PostRequest.h"
#import <NSDate+TimeAgo/NSDate+TimeAgo.h>

@implementation CheckInListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.title = @"Check Ins";
    [self.view makeToastActivity];
    [[[PostRequest alloc] init] exec:@"posts/get" params:nil delegate:self callback:@selector(didFinishDownloadingPosts:)];
}

- (void)didFinishDownloadingPosts:(id)response {
    posts = response;
    [self.collectionView reloadData];
    [self.view hideToastActivity];
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
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[unixFormat intValue]];
    return [date timeAgoWithLimit:86400 dateFormat:NSDateFormatterShortStyle andTimeFormat:NSDateFormatterShortStyle];
}

@end

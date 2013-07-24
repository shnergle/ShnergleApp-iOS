//
//  ScoreViewController.m
//  ShnergleApp
//
//  Created by Harshita Balaga on 15/07/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "ScoreViewController.h"
#import <Toast/Toast+UIView.h>
#import "PostRequest.h"

@implementation ScoreViewController

- (void)setHeaderTitle:(NSString *)headerTitle andSubtitle:(NSString *)headerSubtitle {
    CGRect headerTitleSubtitleFrame = CGRectMake(0, 0, 200, 44);
    UIView *headerTitleSubtitleView = [[UILabel alloc] initWithFrame:headerTitleSubtitleFrame];
    headerTitleSubtitleView.backgroundColor = [UIColor clearColor];
    headerTitleSubtitleView.autoresizesSubviews = YES;
    CGRect titleFrame = CGRectMake(0, 2, 200, 24);
    UILabel *titleView2 = [[UILabel alloc] initWithFrame:titleFrame];
    titleView2.backgroundColor = [UIColor clearColor];
    titleView2.font = [UIFont systemFontOfSize:20.0];
    titleView2.textAlignment = NSTextAlignmentCenter;
    titleView2.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
    titleView2.shadowColor = [UIColor darkGrayColor];
    titleView2.shadowOffset = CGSizeMake(0, 0);
    titleView2.text = headerTitle;
    titleView2.adjustsFontSizeToFitWidth = YES;
    [headerTitleSubtitleView addSubview:titleView2];
    
    CGRect subtitleFrame = CGRectMake(0, 24, 200, 20);
    UILabel *subtitleView2 = [[UILabel alloc] initWithFrame:subtitleFrame];
    subtitleView2.backgroundColor = [UIColor clearColor];
    subtitleView2.font = [UIFont systemFontOfSize:12.0];
    subtitleView2.textAlignment = NSTextAlignmentCenter;
    subtitleView2.textColor = [UIColor colorWithRed:51.0 / 250 green:140.0 / 250 blue:16.0 / 250 alpha:1.0];
    subtitleView2.shadowColor = [UIColor clearColor];
    subtitleView2.shadowOffset = CGSizeMake(0, 0);
    subtitleView2.text = headerSubtitle;
    subtitleView2.adjustsFontSizeToFitWidth = YES;
    [headerTitleSubtitleView addSubview:subtitleView2];
    
    headerTitleSubtitleView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
                                                UIViewAutoresizingFlexibleRightMargin |
                                                UIViewAutoresizingFlexibleTopMargin |
                                                UIViewAutoresizingFlexibleBottomMargin);
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToFollow)];
    [headerTitleSubtitleView addGestureRecognizer:tapGestureRecognizer];
    
    self.navigationItem.titleView = headerTitleSubtitleView;
    self.navigationItem.titleView.userInteractionEnabled = YES;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setHeaderTitle:@"Shnergle Score" andSubtitle:appDelegate.fullName];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.youShare.text = appDelegate.youShare;
    NSNumber *score = @([self.youShare.text intValue]*[self.valueShare.text intValue]);
    self.scoreShare.text = [score stringValue];
    self.youCheckIn.text = appDelegate.checkIn;
    NSNumber *scorecheck = @([self.youCheckIn.text intValue]*[self.valueCheckIn.text intValue]);
    self.scoreCheckIn.text = [scorecheck stringValue];
    //NSNumber *total = @([self.scoreCheckIn.text intValue]+[self.scoreShare.text intValue]);
    self.totalShnergleScore.text = appDelegate.totalScore;

}


@end

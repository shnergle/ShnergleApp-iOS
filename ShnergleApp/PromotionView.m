//
//  PromotionView.m
//  ShnergleApp
//
//  Created by Stian Johansen on 19/4/13.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "PromotionView.h"
#import "VenueViewController.h"
#import "PromotionDetailView.h"


@implementation PromotionView

/*
   // Only override drawRect: if you perform custom drawing.
   // An empty implementation adversely affects performance during animation.
   - (void)drawRect:(CGRect)rect
   {
   // Drawing code
   }
 */

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = @"Promotion";
}

- (IBAction)tapUseDeal:(id)sender {
    PromotionDetailView *promotionDetailView = [[NSBundle mainBundle] loadNibNamed:@"PromotionDetailView" owner:self options:nil][0];
    [promotionDetailView view];
    [self.navigationController pushViewController:promotionDetailView animated:YES];
}

- (void)setpromotionTitle:(NSString *)contents {
    self.promotionTitle.font = [UIFont fontWithName:@"Roboto" size:self.promotionTitle.font.pointSize];
    self.promotionTitle.textAlignment = NSTextAlignmentCenter;
    self.promotionTitle.text = contents;
}

- (void)setpromotionBody:(NSString *)contents {
    self.promotionBody.font = [UIFont fontWithName:@"Roboto" size:self.promotionBody.font.pointSize];
    self.promotionBody.textColor = [UIColor whiteColor];
    self.promotionBody.textAlignment = NSTextAlignmentCenter;
    self.promotionBody.text = contents;
}

- (void)setpromotionExpiry:(NSString *)contents {
    self.promotionExpiry.font = [UIFont fontWithName:@"Roboto" size:self.promotionExpiry.font.pointSize];
    self.promotionExpiry.textAlignment = NSTextAlignmentCenter;
    self.promotionExpiry.text = contents;
}

@end

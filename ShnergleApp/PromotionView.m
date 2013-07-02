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
    self.promotionTitle.text = contents;
    self.promotionTitle.font = [UIFont systemFontOfSize:self.promotionTitle.font.pointSize];
    self.promotionTitle.textAlignment = NSTextAlignmentCenter;
}

- (void)setpromotionBody:(NSString *)contents {
    self.promotionBody.text = contents;
    self.promotionBody.font = [UIFont systemFontOfSize:self.promotionBody.font.pointSize];
    self.promotionBody.textColor = [UIColor whiteColor];
    self.promotionBody.textAlignment = NSTextAlignmentCenter;
}

- (void)setpromotionExpiry:(NSString *)contents {
    self.promotionExpiry.text = contents;
    self.promotionExpiry.font = [UIFont systemFontOfSize:self.promotionExpiry.font.pointSize];
    self.promotionExpiry.textAlignment = NSTextAlignmentCenter;
}

@end

//
//  PromotionView.h
//  ShnergleApp
//
//  Created by Stian Johansen on 19/4/13.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "CustomBackViewController.h"

@interface PromotionView : CustomBackViewController
@property (weak, nonatomic) IBOutlet UILabel *promotionBody;
@property (weak, nonatomic) IBOutlet UILabel *promotionTitle;
@property (weak, nonatomic) IBOutlet UILabel *promotionExpiry;
@property (weak, nonatomic) IBOutlet UILabel *promotionClaimed;
@property (weak, nonatomic) IBOutlet UILabel *promotionLevel;

- (void)setpromotionTitle:(NSString *)contents;
- (void)setpromotionBody:(NSString *)contents;
- (void)setpromotionExpiry:(NSString *)contents;
- (void)setpromotionClaimed:(NSString *)contents;
- (void)setpromotionLevel:(NSString *)contents;

- (IBAction)tapUseDeal:(id)sender;
@end

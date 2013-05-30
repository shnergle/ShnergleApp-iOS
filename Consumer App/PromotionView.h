//
//  PromotionView.h
//  Consumer App
//
//  Created by Stian Johansen on 19/4/13.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PromotionView : UIView
@property (weak, nonatomic) IBOutlet UILabel *promotionBody;
@property (weak, nonatomic) IBOutlet UILabel *promotionTitle;
@property (weak, nonatomic) IBOutlet UILabel *promotionExpiry;

- (IBAction)tapUseDeal:(id)sender;
@end

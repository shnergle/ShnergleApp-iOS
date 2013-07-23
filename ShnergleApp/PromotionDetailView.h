//
//  PromotionDetailView.h
//  ShnergleApp
//
//  Created by Stian Johansen on 19/4/13.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "CustomBackViewController.h"

@interface PromotionDetailView : CustomBackViewController
- (IBAction)tapDone:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *promotionPasscodeLabel;

@end

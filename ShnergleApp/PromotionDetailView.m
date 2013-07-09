//
//  PromotionDetailView.m
//  ShnergleApp
//
//  Created by Stian Johansen on 19/4/13.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "PromotionDetailView.h"

@implementation PromotionDetailView


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = @"Promotion";
}

- (IBAction)tapDone:(id)sender {
    [self goBack];
}

@end

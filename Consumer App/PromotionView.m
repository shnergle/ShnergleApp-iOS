//
//  PromotionView.m
//  Consumer App
//
//  Created by Stian Johansen on 19/4/13.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "PromotionView.h"
#import "StoryboardLayersNavigation.h"
#import "VenueViewController.h"


@implementation PromotionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)tapUseDeal:(id)sender {
    
    VenueViewController *parentVC = (VenueViewController *) [self firstAvailableUIViewController];
    
    [parentVC goToPromotionDetailView];
    
}
@end

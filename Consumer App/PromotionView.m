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

@synthesize promotionBody;
@synthesize promotionExpiry;
@synthesize promotionTitle;

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

-(void)setpromotionTitle:(NSString *) contents
{
    self.promotionTitle.font = [UIFont fontWithName:@"Roboto" size:self.promotionTitle.font.pointSize];
    self.promotionTitle.textAlignment = NSTextAlignmentCenter;
    self.promotionTitle.text = contents;
}
-(void)setpromotionBody:(NSString *) contents
{
    self.promotionBody.font = [UIFont fontWithName:@"Roboto" size:self.promotionBody.font.pointSize];
    self.promotionBody.textColor = [UIColor whiteColor];
    self.promotionBody.textAlignment = NSTextAlignmentCenter;
    self.promotionBody.text = contents;

}
-(void)setpromotionExpiry:(NSString *) contents
{
    self.promotionExpiry.font = [UIFont fontWithName:@"Roboto" size:self.promotionExpiry.font.pointSize];
    self.promotionExpiry.textAlignment = NSTextAlignmentCenter;
    self.promotionExpiry.text = contents;
}

@end

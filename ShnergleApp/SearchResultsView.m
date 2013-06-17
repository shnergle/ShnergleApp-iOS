//
//  SearchResultsView.m
//  ShnergleApp
//
//  Created by Stian Johansen on 17/06/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "SearchResultsView.h"

@implementation SearchResultsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void)hide{


[UIView animateWithDuration:0.5
                 animations:^{
                     self.frame = CGRectMake(320,
                                             self.frame.origin.y,
                                             self.frame.size.width,
                                             self.frame.size.height);
                 }];


}

-(void)show{
    
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.frame = CGRectMake(0,
                                                 self.frame.origin.y,
                                                 self.frame.size.width,
                                                 self.frame.size.height);
                     }];
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

//
//  overlayText.m
//  Consumer App
//
//  Created by Stian Johansen on 3/28/13.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "overlayText.h"

#define TABBAR_HEIGHT (149)


@implementation overlayText
{
    NSInteger minimisedHeight;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}




// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    self.frame = CGRectMake(self.frame.origin.x, 200, self.frame.size.width, self.frame.size.height);
}


- (IBAction)swipeDown:(id)sender {
    [self setTabBarHidden:true animated:true];
    NSLog(@"SwipeDown");
    /*if the box is already swiped down, ignore
    if(self.frame.origin.y > 200){
        
    }else if(self.frame.origin.y < 200){
        self.frame = CGRectMake(self.frame.origin.x, 200, self.frame.size.width, self.frame.size.height);
    }else{
        self.frame = CGRectMake(self.frame.origin.x, 390, self.frame.size.width, self.frame.size.height);
    }
     */
}

- (IBAction)swipeUp:(id)sender {
    
    [self setTabBarHidden:false animated:true];
    NSLog(@"SwipeUP");
    /*if(self.frame.origin.y > 200){
        self.frame = CGRectMake(self.frame.origin.x, 200, self.frame.size.width, self.frame.size.height);
    }else if(self.frame.origin.y <= 200){
        self.frame = CGRectMake(self.frame.origin.x, 50, self.frame.size.width, self.frame.size.height);
    }*/
}


- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated
{
    NSLog(@"setTabBarHidden:%d animated:%d", hidden, animated);
    
	if ( [self.subviews count] < 2 )
		return;
	
	UIView *contentView;
    
	if ( [[self.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] )
		contentView = [self.subviews objectAtIndex:1];
	else
		contentView = [self.subviews objectAtIndex:0];
	
    
    if(hidden)
    {
        if(animated)
        {
            
            [UIView animateWithDuration:0.2
                             animations:^{
                                 contentView.frame = self.bounds;
                                 
                                 self.frame = CGRectMake(self.bounds.origin.x,
                                                         self.bounds.size.height,
                                                         self.bounds.size.width,
                                                         TABBAR_HEIGHT);
                             }
                             completion:^(BOOL finished) {
                                 self.frame = CGRectMake(self.bounds.origin.x,
                                                         self.bounds.size.height,
                                                         self.bounds.size.width,
                                                         TABBAR_HEIGHT);
                             }];
        }
        else
        {
            
            contentView.frame = self.bounds;
            
            self.frame = CGRectMake(self.bounds.origin.x,
                                    self.bounds.size.height,
                                    self.bounds.size.width,
                                    TABBAR_HEIGHT);
        }
    }
    else
    {
        self.frame = CGRectMake(self.bounds.origin.x,
                                self.bounds.size.height,
                                self.bounds.size.width,
                                0);
        if(animated)
        {
            [UIView animateWithDuration:0.2
                             animations:^{
                                 self.frame = CGRectMake(self.bounds.origin.x,
                                                         self.bounds.size.height - TABBAR_HEIGHT,
                                                         self.bounds.size.width,
                                                         TABBAR_HEIGHT);
                             }   completion:^(BOOL finished) {
                                 contentView.frame = CGRectMake(self.bounds.origin.x,
                                                                self.bounds.origin.y,
                                                                self.bounds.size.width,
                                                                self.bounds.size.height - TABBAR_HEIGHT);
                             }];
        }
        else
        {
            contentView.frame = CGRectMake(self.bounds.origin.x,
                                           self.bounds.origin.y,
                                           self.bounds.size.width,
                                           self.bounds.size.height - TABBAR_HEIGHT);
            
            self.frame = CGRectMake(self.bounds.origin.x,
                                    self.bounds.size.height - TABBAR_HEIGHT,
                                    self.bounds.size.width,
                                    TABBAR_HEIGHT);
        }
    }
}

@end

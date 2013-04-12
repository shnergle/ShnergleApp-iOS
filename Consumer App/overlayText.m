//
//  overlayText.m
//  Consumer App
//
//  Created by Stian Johansen on 3/28/13.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "overlayText.h"

#define TABBAR_HEIGHT (45)

@implementation overlayText
{
}


- (id)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0,250, self.frame.size.width,self.frame.size.height);
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}






/* Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
  //self.frame = CGRectMake(self.frame.origin.x, 250, self.frame.size.width, self.frame.size.height);
}*/


- (IBAction)swipeDown:(id)sender {
    //[self setTabBarHidden:false animated:true];
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
    
    //[self setTabBarHidden:true animated:true];
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
    
	
		contentView = self;
	
    
    if(hidden) //IF hidden, then show:
    {
        if(animated)
        {
            
            [UIView animateWithDuration:2.0 delay:0.2 options: UIViewAnimationCurveEaseOut
                             animations:^{
                                 //contentView.frame = self.bounds;
                                 
                                 self.frame = CGRectMake(self.bounds.origin.x,
                                                         350,
                                                         self.bounds.size.width,
                                                         self.bounds.size.height /*TABBAR_HEIGHT*/);
                             }
                             completion:^(BOOL finished) {
                                 self.frame = CGRectMake(self.bounds.origin.x,
                                                         350,
                                                         self.bounds.size.width,
                                                         self.bounds.size.height/*TABBAR_HEIGHT*/);
                             }];
        }
    }
    else //else hide:
    {
        self.frame = CGRectMake(self.bounds.origin.x,
                                350,
                                self.bounds.size.width,
                                self.bounds.size.height);
        if(animated)
        {
            [UIView animateWithDuration:2.0
                             animations:^{
                                 self.frame = CGRectMake(self.bounds.origin.x,
                                                         250,
                                                         self.bounds.size.width,
                                                         self.bounds.size.height);
                             }   completion:^(BOOL finished) {
                                 contentView.frame = CGRectMake(self.bounds.origin.x,
                                                                250,
                                                                self.bounds.size.width,
                                                                self.bounds.size.height);
                             }];
        }
    }
}

@end

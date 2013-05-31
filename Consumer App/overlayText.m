//
//  overlayText.m
//  Consumer App
//
//  Created by Stian Johansen on 3/28/13.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "overlayText.h"
#import "StoryboardLayersNavigation.h" //for getting the viewcontroller from this view.
#import "PromotionViewController.h"
#import "VenueViewController.h"

#define TABBAR_HEIGHT (45)

@implementation overlayText
{

}

- (id)initWithFrame:(CGRect)frame
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;


    frame = CGRectMake(0,screenHeight-70, self.frame.size.width,self.frame.size.height);
    self = [super initWithFrame:frame];

    if (self) {

    }
    return self;
}

@synthesize offerContents;
@synthesize offerCount;
@synthesize offerHeadline;
@synthesize venueMap;





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
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;

    [self hideAnimated:self.frame.origin.y animationDuration:0.5 targetSize:screenHeight-160 contentView:self];

}

- (IBAction)swipeUp:(id)sender {

    //[self setTabBarHidden:true animated:true];
    NSLog(@"SwipeUP");

    [self showAnimated:50 animationDelay:0.2 animationDuration:0.5];

}




- (void)hideAnimated:(NSInteger)originalSize animationDuration:(double)animationDuration targetSize:(NSInteger)targetSize contentView:(UIView *)contentView
{
    self.frame = CGRectMake(self.bounds.origin.x,
                            originalSize,
                            self.bounds.size.width,
                            self.bounds.size.height);

    [UIView animateWithDuration:animationDuration
     animations:^{
         self.frame = CGRectMake(self.bounds.origin.x,
                                 targetSize,
                                 self.bounds.size.width,
                                 self.bounds.size.height);
     }   completion:^(BOOL finished) {
         contentView.frame = CGRectMake(self.bounds.origin.x,
                                        targetSize,
                                        self.bounds.size.width,
                                        self.bounds.size.height);
     }];
}

- (void)showAnimated:(NSInteger)targetSize animationDelay:(double)animationDelay animationDuration:(double)animationDuration
{
    [UIView animateWithDuration:animationDuration delay:animationDelay options:(UIViewAnimationOptions)UIViewAnimationCurveEaseOut
     animations:^{
         //contentView.frame = self.bounds;

         self.frame = CGRectMake(self.bounds.origin.x,
                                 targetSize,
                                 self.bounds.size.width,
                                 self.bounds.size.height /*TABBAR_HEIGHT*/);
     }
     completion:^(BOOL finished) {
         self.frame = CGRectMake(self.bounds.origin.x,
                                 targetSize,
                                 self.bounds.size.width,
                                 self.bounds.size.height /*TABBAR_HEIGHT*/);
     }];
}

- (void)setTabBarHidden:(BOOL)hide animated:(BOOL)animated
{

    if ( [self.subviews count] < 2 )
        return;

    UIView *contentView;


    contentView = self;

    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;


    if(hide)
    {
        NSInteger targetSize = screenHeight-160;
        double animationDuration = 0.5;
        double animationDelay = 0.2;

        [self showAnimated:targetSize animationDelay:animationDelay animationDuration:animationDuration];

    }
    else
    {
        NSInteger targetSize = screenHeight-160;
        NSInteger originalSize = screenHeight-70;

        [self hideAnimated:originalSize animationDuration:0.5 targetSize:targetSize contentView:contentView];

    }
}

- (IBAction)tapPromotion:(id)sender {

    VenueViewController *parentVC = (VenueViewController *)[self firstAvailableUIViewController];


    // do any setup you need for myNewVC

    [parentVC goToPromotionView];


}





@end

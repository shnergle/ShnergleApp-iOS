//
//  overlayText.h
//  Consumer App
//
//  Created by Stian Johansen on 3/28/13.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface overlayText : UIView

- (IBAction)swipeDown:(id)sender;
- (IBAction)swipeUp:(id)sender;
- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated;
- (IBAction)tapPromotion:(id)sender;

- (void)hideAnimated:(NSInteger)originalSize animationDuration:(double)animationDuration targetSize:(NSInteger)targetSize contentView:(UIView *)contentView;
- (void)showAnimated:(NSInteger)targetSize animationDelay:(double)animationDelay animationDuration:(double)animationDuration;

@end

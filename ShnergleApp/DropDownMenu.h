//
//  DropDownMenu.h
//  ShnergleApp
//
//  Created by Stian Johansen on 03/05/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropDownMenu : UIView
- (void)hideAnimated:(NSInteger)originalSize animationDuration:(double)animationDuration targetSize:(NSInteger)targetSize contentView:(UIView *)contentView;

- (void)showAnimated:(NSInteger)targetSize animationDelay:(double)animationDelay animationDuration:(double)animationDuration;
@end

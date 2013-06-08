//
//  DropDownMenu.m
//  ShnergleApp
//
//  Created by Stian Johansen on 03/05/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "DropDownMenu.h"

@implementation DropDownMenu

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //
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

- (void)hideAnimated:(NSInteger)originalSize animationDuration:(double)animationDuration targetSize:(NSInteger)targetSize contentView:(UIView *)contentView {
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

- (void)showAnimated:(NSInteger)targetSize animationDelay:(double)animationDelay animationDuration:(double)animationDuration {
    [DropDownMenu animateWithDuration:animationDuration delay:animationDelay options:(UIViewAnimationOptions)UIViewAnimationCurveEaseOut
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

@end

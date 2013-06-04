//
//  OverlayText.h
//  ShnergleApp
//
//  Created by Stian Johansen on 3/28/13.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
@interface OverlayText : UIView {
    BOOL isUp;
}

- (IBAction)swipeDown:(id)sender;
- (IBAction)swipeUp:(id)sender;
- (void)setTabBarHidden:(BOOL)hide animated:(BOOL)animated;
- (IBAction)tapPromotion:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *offerHeadline;
@property (weak, nonatomic) IBOutlet UILabel *offerContents;
@property (weak, nonatomic) IBOutlet UILabel *offerCount;
@property (weak, nonatomic) IBOutlet GMSMapView *venueMap;
@property (weak, nonatomic) UIViewController *caller;

- (void)hideAnimated:(NSInteger)originalSize animationDuration:(double)animationDuration targetSize:(NSInteger)targetSize contentView:(UIView *)contentView;
- (void)showAnimated:(NSInteger)targetSize animationDelay:(double)animationDelay animationDuration:(double)animationDuration;

@end

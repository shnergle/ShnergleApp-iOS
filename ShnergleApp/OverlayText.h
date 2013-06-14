//
//  OverlayText.h
//  ShnergleApp
//
//  Created by Stian Johansen on 3/28/13.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <Toast+UIView.h>

@interface OverlayText : UIView {
    BOOL isUp;
}

- (IBAction)swipeDown:(id)sender;
- (IBAction)swipeUp:(id)sender;
- (void)setTabBarHidden:(BOOL)hide animated:(BOOL)animated;
- (IBAction)tapPromotion:(id)sender;
- (IBAction)tapPullerMenu:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *offerHeadline;
@property (weak, nonatomic) IBOutlet UILabel *offerContents;
@property (weak, nonatomic) IBOutlet UILabel *offerCount;
@property (weak, nonatomic) IBOutlet GMSMapView *venueMap;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIImageView *commentButton;

@property (weak, nonatomic) IBOutlet UIButton *postUpdateButton;

@property (weak, nonatomic) IBOutlet UIView *parentViewInside;
@property (weak, nonatomic) IBOutlet UILabel *goingLabel;
@property (weak, nonatomic) IBOutlet UILabel *thinkingLabel;
@property (weak, nonatomic) IBOutlet UILabel *checkedInLabel;

- (IBAction)tappedGoing:(id)sender;
- (IBAction)tappedThinking:(id)sender;

@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *tapGoing;
@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *tapThinking;



- (void)hideAnimated:(NSInteger)originalSize animationDuration:(double)animationDuration targetSize:(NSInteger)targetSize contentView:(UIView *)contentView;
- (void)showAnimated:(NSInteger)targetSize animationDelay:(double)animationDelay animationDuration:(double)animationDuration;
- (void)didAppear;

@end

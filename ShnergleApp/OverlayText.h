//
//  OverlayText.h
//  ShnergleApp
//
//  Created by Stian Johansen on 3/28/13.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface OverlayText : UIView <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *rsvpQuestionLabel;

@property (weak, nonatomic) IBOutlet UILabel *promotionHeadline;
@property (weak, nonatomic) IBOutlet UILabel *promotionContents;
@property (weak, nonatomic) IBOutlet UIImageView *promotionImage;
@property (weak, nonatomic) IBOutlet UIButton *claimVenueButton;
@property (weak, nonatomic) IBOutlet UILabel *promotionCount;
@property (weak, nonatomic) IBOutlet MKMapView *venueMap;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *intentionConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *intentionHeightConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *analyticsShareConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *analyticsLeftConstraints;

@property (weak, nonatomic) IBOutlet UIButton *postUpdateButton;
@property (weak, nonatomic) IBOutlet UITextView *summaryContentTextField;
@property (weak, nonatomic) IBOutlet UITextField *summaryHeadlineTextField;
@property (weak, nonatomic) IBOutlet UIButton *publishButton;

@property (weak, nonatomic) IBOutlet UIView *parentViewInside;
@property (weak, nonatomic) IBOutlet UILabel *goingLabel;
@property (weak, nonatomic) IBOutlet UILabel *thinkingLabel;
@property (weak, nonatomic) IBOutlet UIButton *thinkingView;
@property (weak, nonatomic) IBOutlet UIButton *goingView;
@property (weak, nonatomic) IBOutlet UITextView *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextView *emailTextField;
@property (weak, nonatomic) IBOutlet UITextView *websiteTextField;

@property (weak, nonatomic) IBOutlet UIButton *staffButton;
@property (weak, nonatomic) IBOutlet UILabel *staffLabel;
@property (weak, nonatomic) IBOutlet UIImageView *staffImage;
@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *tapPromotion;

@property (weak, nonatomic) IBOutlet UIButton *analyticsButton;
@property (weak, nonatomic) IBOutlet UILabel *analyticsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *analyticsImage;

@property (weak, nonatomic) IBOutlet UIButton *mainShareButton;
@property (weak, nonatomic) IBOutlet UILabel *shareLabel;
@property (weak, nonatomic) IBOutlet UIImageView *shareImage;

@property (weak, nonatomic) IBOutlet UIImageView *Done;
@property (weak, nonatomic) IBOutlet UIImageView *Change;

- (void)setTabBarHidden:(BOOL)hide animated:(BOOL)animated;
- (void)hideAnimated:(NSInteger)originalSize animationDuration:(double)animationDuration targetSize:(NSInteger)targetSize contentView:(UIView *)contentView;
- (void)showAnimated:(NSInteger)targetSize animationDelay:(double)animationDelay animationDuration:(double)animationDuration;
- (void)didAppear;

@end

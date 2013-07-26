//
//  OverlayText.h
//  ShnergleApp
//
//  Created by Stian Johansen on 3/28/13.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>
#import <YIPopupTextView/YIPopupTextView.h>

@interface OverlayText : UIView <UITableViewDataSource, UITableViewDelegate, YIPopupTextViewDelegate> {
    BOOL isUp;
    
    NSArray *tableData;
}

- (IBAction)swipeDown:(id)sender;
- (IBAction)swipeUp:(id)sender;
- (void)setTabBarHidden:(BOOL)hide animated:(BOOL)animated;
- (IBAction)tapPromotion:(id)sender;
- (IBAction)tapPullerMenu:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *promotionHeadline;
@property (weak, nonatomic) IBOutlet UILabel *promotionContents;
@property (weak, nonatomic) IBOutlet UIImageView *promotionImage;
@property (weak, nonatomic) IBOutlet UIButton *claimVenueButton;
- (IBAction)tappedClaimVenue:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *promotionCount;
@property (weak, nonatomic) IBOutlet GMSMapView *venueMap;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIImageView *commentButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *intentionConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *intentionHeightConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *analyticsShareConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *analyticsLeftConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentsHeightConstraints;

@property (weak, nonatomic) IBOutlet UIButton *postUpdateButton;
@property (weak, nonatomic) IBOutlet UITextView *summaryContentTextField;
@property (weak, nonatomic) IBOutlet UITextField *summaryHeadlineTextField;
@property (weak, nonatomic) IBOutlet UIButton *publishButton;

@property (weak, nonatomic) IBOutlet UIView *parentViewInside;
@property (weak, nonatomic) IBOutlet UILabel *goingLabel;
@property (weak, nonatomic) IBOutlet UILabel *thinkingLabel;
@property (weak, nonatomic) IBOutlet UILabel *checkedInLabel;
@property (weak, nonatomic) IBOutlet UIButton *thinkingView;
@property (weak, nonatomic) IBOutlet UIButton *goingView;
@property (weak, nonatomic) IBOutlet UIButton *checkedInView;

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

@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *tapGoing;
@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *tapThinking;


@property (weak, nonatomic) IBOutlet UIImageView *Done;
@property (weak, nonatomic) IBOutlet UIImageView *Change;



- (IBAction)tappedGoing:(id)sender;
- (IBAction)tappedThinking:(id)sender;

- (IBAction)postUpdateTapped:(id)sender;
- (void)hideAnimated:(NSInteger)originalSize animationDuration:(double)animationDuration targetSize:(NSInteger)targetSize contentView:(UIView *)contentView;
- (void)showAnimated:(NSInteger)targetSize animationDelay:(double)animationDelay animationDuration:(double)animationDuration;
- (void)didAppear;

@property (weak, nonatomic) IBOutlet UITableView *commentsTableView;
//@property (weak, nonatomic) IBOutlet UITableViewCell *tableCell;




@end

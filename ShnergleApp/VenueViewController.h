//
//  VenueViewController.h
//  ShnergleApp
//
//  Created by Stian Johansen on 3/22/13.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "OverlayText.h"
#import "CustomBackViewController.h"

@interface VenueViewController : CustomBackViewController<UICollectionViewDataSource, UICollectionViewDelegate, UIAlertViewDelegate, CLLocationManagerDelegate> {
    NSString *promotionTitle;
    NSString *promotionBody;
    NSString *promotionExpiry;
    NSString *promotionUntil;
    NSString *promotionLevel;
    NSInteger selectedPost;

    BOOL textViewOpen;

    NSString *titleHeader;

    BOOL following;

    double venueLat;
    double venueLon;
    NSString *summaryContent;
    NSString *summaryHeadline;

    UIRefreshControl *refreshControl;

    OverlayText *overlayView;

    CLLocationManager *man;
    NSArray *posts;
}

- (void)goToPromotionView;
- (void)setVenueInfo;
@property (weak, nonatomic) IBOutlet UICollectionView *crowdCollectionV;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *checkInButton;

- (void)reloadOverlay;

@end

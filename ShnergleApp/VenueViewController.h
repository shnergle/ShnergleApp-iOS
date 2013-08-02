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

    NSMutableDictionary *cellImages;

    UIRefreshControl *refreshControl;

    OverlayText *overlayView;

    CLLocationManager *man;
    NSArray *posts;
}
- (void)viewDidAppear:(BOOL)animated;
- (void)viewWillAppear:(BOOL)animated;
- (void)goToPromotionView;
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;
- (void)setHeaderTitle:(NSString *)headerTitle andSubtitle:(NSString *)headerSubtitle;
- (void)setVenueInfo;
@property (weak, nonatomic) IBOutlet UICollectionView *crowdCollectionV;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *checkInButton;

- (void)reloadOverlay;
- (void)configureMapWithLat:(CLLocationDegrees)lat longitude:(CLLocationDegrees)lon;
- (NSString *)getDateFromUnixFormat:(id)unixFormat;
@end

//
//  VenueViewController.h
//  ShnergleApp
//
//  Created by Stian Johansen on 3/22/13.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OverlayText.h"
#import "CustomBackViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface VenueViewController : CustomBackViewController<UICollectionViewDataSource, UICollectionViewDelegate, UIAlertViewDelegate> {
    NSString *promotionTitle;
    NSString *promotionBody;
    NSString *promotionExpiry;
    NSInteger selectedPost;

    BOOL textViewOpen;
    BOOL hidden;

    NSString *titleHeader;

    BOOL following;

    double venueLat;
    double venueLon;
    NSString *summaryContent;
    NSString *summaryHeadline;
}
- (void)setVenue:(NSDictionary *)venue;
- (void)viewDidAppear:(BOOL)animated;
- (void)viewWillAppear:(BOOL)animated;
- (void)goToPromotionView;
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;
- (void)setHeaderTitle:(NSString *)headerTitle andSubtitle:(NSString *)headerSubtitle;


@property (weak, nonatomic) IBOutlet UICollectionView *crowdCollectionV;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *checkInButton;

@property (weak, nonatomic) OverlayText *overlayView;
@property (weak, nonatomic) UIView *naviview;
- (void)configureMapWithLat:(CLLocationDegrees)lat longitude:(CLLocationDegrees)lon;
- (NSString *)getDateFromUnixFormat:(id)unixFormat;
@end

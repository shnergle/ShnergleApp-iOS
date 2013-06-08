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

@interface VenueViewController : CustomBackViewController<UICollectionViewDataSource, UICollectionViewDelegate>{
    NSString *promotionTitle;
    NSString *promotionBody;
    NSString *promotionExpiry;
    NSInteger selectedImage;

    BOOL textViewOpen;

    //Scrollhide
    CGFloat startContentOffset;
    CGFloat lastContentOffset;
    BOOL hidden;
}
- (void)setTitle:(NSString *)title;
- (void)viewDidAppear:(BOOL)animated;
- (void)viewWillAppear:(BOOL)animated;
- (void)goToPromotionView;
- (void)goToPromotionDetailView;
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;

@property (weak, nonatomic) IBOutlet UICollectionView *crowdCollectionV;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *checkInButton;

@property (weak, nonatomic) OverlayText *overlayView;
- (void)configureMapWithLat:(CLLocationDegrees)lat longitude:(CLLocationDegrees)lon;
@end

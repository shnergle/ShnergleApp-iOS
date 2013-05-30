//
//  VenueViewController.h
//  Consumer App
//
//  Created by Stian Johansen on 3/22/13.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "overlayText.h"
#import "TransitionViewController.h"

@interface VenueViewController : ViewController
@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;
-(void)setTitle:(NSString *)title;
-(void)viewDidAppear:(BOOL)animated;
-(void)viewWillAppear:(BOOL)animated;
-(void)goToPromotionView;
-(void)goToPromotionDetailView;
-(void)goBack;
- (UIBarButtonItem *)createLeftBarButton:(NSString *)imageName actionSelector:(SEL)actionSelector;
@property (weak, nonatomic) IBOutlet UICollectionView *crowdCollectionV;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *checkInButton;

@property (weak, nonatomic) IBOutlet overlayText *overlayView;
-(void)configureMapWithLat:(CLLocationDegrees )lat longitude:(CLLocationDegrees )lon;
@end

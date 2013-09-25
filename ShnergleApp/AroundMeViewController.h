//
//  AroundMeViewController.h
//  ShnergleApp
//
//  Created by Stian Johansen on 3/21/13.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "OverlayText.h"

@interface AroundMeViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, MKMapViewDelegate> {
    BOOL crowdImagesHidden;
    BOOL dropDownHidden;
    BOOL hasPositionLocked;
    BOOL pinDropped;
    CLLocationCoordinate2D pinDroppedLocation;
    MKMapView *map;
    NSArray *venues;
    BOOL rendered;
}
@property (weak, nonatomic) IBOutlet UIButton *drawerCloseButton;
@property (weak, nonatomic) IBOutlet OverlayText *distanceScrollerView;
@property (weak, nonatomic) IBOutlet UISlider *distanceScroller;
@property (weak, nonatomic) IBOutlet UICollectionView *crowdCollection;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *navBarMenuItem;
@property (weak, nonatomic) IBOutlet OverlayText *overlay;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *checkInButton;
@end

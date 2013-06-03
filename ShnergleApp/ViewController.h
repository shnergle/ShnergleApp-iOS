//
//  ViewController.h
//  ShnergleApp
//
//  Created by Stian Johansen on 3/21/13.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "OverlayText.h"
#import "DropDownMenu.h"
#import <ECSlidingViewController.h>
#import <QuartzCore/QuartzCore.h> // shadow and border

NSInteger selectedVenueIndex;


@interface ViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate,GMSMapViewDelegate> {
    NSArray *venueNames;
    NSArray *images;
    NSInteger selectedVenue;
    BOOL crowdImagesHidden;
    BOOL dropDownHidden;
    BOOL hasPositionLocked;

}
//@property (weak, nonatomic) IBOutlet UIImageView *dropDownIndicator;
@property (weak, nonatomic) IBOutlet UIButton *drawerCloseButton;
@property (weak, nonatomic) IBOutlet OverlayText *distanceScrollerView;
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UICollectionView *crowdCollection;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *navBarMenuItem;
- (IBAction)tapArrow:(id)sender;
- (void)mapView:(GMSMapView *)mapView
    didTapAtCoordinate:(CLLocationCoordinate2D)coordinate;
@property (weak, nonatomic) IBOutlet OverlayText *overlay;
//@property(nonatomic, retain) UIView *titleView;
//@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
//@property (weak, nonatomic) IBOutlet DropDownMenu *dropDownMenu;
-(BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *checkInButton;
//-(void)createTitleButton;
- (IBAction)tapMap:(id)sender;
-(void)initMap;
- (void)tapMenu;
- (IBAction)tapMenu:(id)sender;

-(void)hideOverlay;
-(void)showOverlay;
-(void)showDistanceScroller;
-(void)hideDistanceScroller;
//-(void)goback;
@end

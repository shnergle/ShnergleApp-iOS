//
//  AroundMeViewController.m
//  ShnergleApp
//
//  Created by Stian Johansen on 3/21/13.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "AroundMeViewController.h"
#import "CrowdItem.h"
#import <CoreLocation/CoreLocation.h>
#import <Toast+UIView.h>
#import "Request.h"
#import "VenueViewController.h"
#import <ECSlidingViewController/ECSlidingViewController.h>
#import "UIViewController+CheckIn.h"
#import <FlurrySDK/Flurry.h>

@implementation AroundMeViewController

- (void)decorateCheckInButton {
    [self.checkInButton setTitleTextAttributes:
     @{NSForegroundColorAttributeName: [UIColor colorWithRed:51.0 / 250 green:140.0 / 250 blue:16.0 / 250 alpha:1.0],
       NSFontAttributeName: [UIFont systemFontOfSize:14.0]}
                                      forState:UIControlStateNormal];
}

- (void)decorateScroller {
    UIImage *maxBarImage = [UIImage imageNamed:@"highlight_distance_02_transparent"];
    UIImage *thumbImage = [UIImage imageNamed:@"highlight_distance"];
    UIImage *minBarImage = [UIImage imageNamed:@"highlight_distance_02_long"];

    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 0, 0);
    minBarImage = [minBarImage resizableImageWithCapInsets:insets];

    [self.distanceScroller setMaximumTrackImage:maxBarImage forState:UIControlStateNormal];
    [self.distanceScroller setMinimumTrackImage:minBarImage forState:UIControlStateNormal];
    [self.distanceScroller setThumbImage:thumbImage forState:UIControlStateNormal];
}

- (UIBarButtonItem *)createLeftBarButton:(NSString *)imageName actionSelector:(SEL)actionSelector {
    UIImage *menuButtonImg = [UIImage imageNamed:imageName];

    UIButton *menuButtonTmp = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButtonTmp.frame = CGRectMake(280.0, 10.0, 22.0, 22.0);
    [menuButtonTmp setBackgroundImage:menuButtonImg forState:UIControlStateNormal];
    [menuButtonTmp addTarget:self action:actionSelector forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:menuButtonTmp];
    return menuButton;
}

- (void)menuButtonDecorations {
    self.navBarMenuItem.leftBarButtonItem = [self createLeftBarButton:@"mainmenu_button" actionSelector:@selector(tapMenu)];
    UIImageView *locImage = [[UIImageView alloc] initWithFrame:CGRectMake(85, 30, 20, 20)];
    locImage.image = [UIImage imageNamed:@"glyphicons_233_direction"];
    [self.navBar addSubview:locImage];
}

- (IBAction)backToMe:(id)sender {
    hasPositionLocked = NO;
    [self mapView:map didUpdateUserLocation:map.userLocation];
    pinDropped = NO;
    [self sliderValueChanged:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self decorateCheckInButton];
    [self decorateScroller];

    crowdImagesHidden = NO;
    dropDownHidden = YES;
    appDelegate.shnergleThis = NO;
    [self menuButtonDecorations];

    self.navBar.barTintColor = [UIColor colorWithRed:233.0 / 255 green:235.0 / 255 blue:240.0 / 255 alpha:1.0];
    self.navBar.translucent = NO;

    id radius = [[NSUserDefaults standardUserDefaults] objectForKey:@"radius"];

    if (!radius) {
        [[NSUserDefaults standardUserDefaults] setObject:@1.0f forKey:@"radius"];
    } else {
        self.distanceScroller.value = [radius floatValue];
        [self sliderValueChanged:nil];
    }
}

- (void)addShadowLineRect:(CGRect)shadeRect ToView:(UIView *)view {
    CALayer *topBorder = [CALayer layer];

    topBorder.frame = shadeRect;

    topBorder.backgroundColor = [UIColor lightGrayColor].CGColor;

    [view.layer addSublayer:topBorder];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.hidesBackButton = YES;
    dropDownHidden = YES;
    crowdImagesHidden = NO;
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.navigationController.navigationBar.clipsToBounds = YES;
    self.navBar.clipsToBounds = YES;

    crowdImagesHidden = NO;

    [self addShadowLineRect:CGRectMake(0.0f, 70.0f, self.distanceScrollerView.frame.size.width, 1.0f) ToView:self.distanceScrollerView];

    [self addShadowLineRect:CGRectMake(0.0f, self.overlay.bounds.origin.y + (35 + 8), self.overlay.frame.size.width, 1.0f) ToView:self.overlay];

    [self initMap];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return venues ? [venues count] : 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    CrowdItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    item.crowdImage.backgroundColor = [UIColor lightGrayColor];

    NSDictionary *key = @{@"entity": @"venue",
                          @"entity_id": venues[indexPath.item][@"id"]};
    if (!(item.crowdImage.image = [Request getImage:key])) {
        [Request post:@"images/get" params:key callback:^(id response) {
            if (response != nil && self.crowdCollection != nil && [self.crowdCollection numberOfItemsInSection:indexPath.section] > indexPath.item) {
                [self.crowdCollection reloadItemsAtIndexPaths:@[indexPath]];
            }
        }];
    }

    item.venueName.text = venues[indexPath.item][@"name"];
    item.venueName.font = [UIFont systemFontOfSize:11.0f];
    item.venueName.textColor = [UIColor whiteColor];

    if ([venues[indexPath.item][@"promotions"] integerValue] > 0) {
        item.promotionIndicator.hidden = NO;
    } else {
        item.promotionIndicator.hidden = YES;
    }

    if ([venues[indexPath.item][@"following"] integerValue] > 0) {
        item.followingIndicator.hidden = NO;
    } else {
        item.followingIndicator.hidden = YES;
    }

    return item;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ToVenueSite"]) {
        [((VenueViewController *)[segue destinationViewController])setVenueInfo];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    appDelegate.activeVenue = venues[indexPath.item];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    appDelegate.activeVenue = venues[indexPath.item];
}

- (void)showOverlay {
    [self.overlay showAnimated:146 animationDelay:0.2 animationDuration:0.5];
    crowdImagesHidden = NO;
}

- (void)hideOverlay {
    [self.overlay hideAnimated:146 animationDuration:0.5 targetSize:350 contentView:[self overlay]];
    crowdImagesHidden = YES;
}

- (void)showDistanceScroller {
    if (self.distanceScrollerView.bounds.origin.y < 64) {
        [[self distanceScrollerView] showAnimated:64 animationDelay:0.0 animationDuration:0.5];
    }
}

- (void)hideDistanceScroller {
    if (self.distanceScrollerView.frame.origin.y > -64) {
        [[self distanceScrollerView] hideAnimated:64 animationDuration:0.8 targetSize:-64 contentView:[self distanceScrollerView]];
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    return YES;
}

- (IBAction)sliderValueChanged:(id)sender {
    [self.overlay makeToastActivity];
    [map removeOverlays:map.overlays];
    CLLocationCoordinate2D coord;
    if (pinDropped) {
        coord = pinDroppedLocation;
    } else {
        coord = map.userLocation.coordinate;
    }

    MKCoordinateRegion rgn = MKCoordinateRegionMakeWithDistance(coord, (self.distanceScroller.value * 1000), (self.distanceScroller.value * 1000));
    double distanceInDegrees = sqrt(pow(rgn.span.latitudeDelta, 2) + pow(rgn.span.longitudeDelta, 2));

    NSDictionary *params = @{@"my_lat": @(coord.latitude),
                             @"my_lon": @(coord.longitude),
                             @"distance": @(distanceInDegrees),
                             @"level": appDelegate.level,
                             @"around_me": @"true"};
    [Request post:@"venues/get" params:params callback:^(id response) {
        @synchronized(self) {
            venues = response;
            [self.crowdCollection reloadData];
            [self.overlay hideToastActivity];
        }
    }];

    MKCircle *circle = [MKCircle circleWithCenterCoordinate:coord radius:self.distanceScroller.value * 1000];
    [map addOverlay:circle];

    [[NSUserDefaults standardUserDefaults] setObject:@(self.distanceScroller.value) forKey:@"radius"];
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay {
    MKCircleView *circleView = [[MKCircleView alloc] initWithCircle:overlay];
    circleView.strokeColor = [UIColor orangeColor];
    circleView.lineWidth = 5;
    return circleView;
}

- (void)tapMenu {
    [self.slidingViewController anchorTopViewTo:ECRight];
    [self showOverlay];
    [self hideDistanceScroller];
    crowdImagesHidden = NO;
    dropDownHidden = YES;
    [self drawerButtonImage:@"arrowDown"];
}

- (void)drawerButtonImage:(NSString *)imagenamed {
    [self.drawerCloseButton setImage:[UIImage imageNamed:imagenamed] forState:UIControlStateNormal];
}

- (IBAction)tapArrow:(id)sender {
    if (crowdImagesHidden) {
        [self showOverlay];
        [self hideDistanceScroller];
        [self drawerButtonImage:@"arrowDown"];
    } else {
        [self hideOverlay];
        [self showDistanceScroller];
        [self drawerButtonImage:@"arrowUp"];
    }
}

- (void)initMap {
    rendered = NO;
    hasPositionLocked = NO;
    map = [[MKMapView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 330)];
    map.delegate = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapAtMap:)];
    [map addGestureRecognizer:tap];
    [self.view addSubview:map];
    [self.view sendSubviewToBack:map];
}

- (void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered {
    if (!rendered && fullyRendered) {
        rendered = YES;
        hasPositionLocked = NO;
        map.showsUserLocation = YES;
        [self sliderValueChanged:nil];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    appDelegate.activeVenue = nil;
    appDelegate.venueDetailsContent = nil;
}

- (void)didTapAtMap:(id)sender {
    [map removeOverlays:map.overlays];
    pinDropped = YES;
    CGPoint point = [sender locationInView:map];
    pinDroppedLocation = [map convertPoint:point toCoordinateFromView:map];
    [self sliderValueChanged:nil];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    if (!hasPositionLocked) {
        hasPositionLocked = YES;
        [Flurry setLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude horizontalAccuracy:userLocation.location.horizontalAccuracy verticalAccuracy:userLocation.location.verticalAccuracy];
        MKMapPoint point = MKMapPointForCoordinate(userLocation.coordinate);
        MKCoordinateRegion region = MKCoordinateRegionForMapRect(MKMapRectMake(point.x, point.y, map.frame.size.width * 50, map.frame.size.height * 50));
        map.region = region;
        CGPoint loc = [map convertCoordinate:userLocation.coordinate toPointToView:map];
        loc.y += 90;
        map.centerCoordinate = [map convertPoint:loc toCoordinateFromView:map];
        [self sliderValueChanged:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [map removeOverlays:map.overlays];
    [map removeFromSuperview];
    map = nil;
}

@end

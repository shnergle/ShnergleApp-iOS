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
#import "MenuViewController.h"
#import <Toast+UIView.h>
#import "Request.h"
#import "VenueViewController.h"
#import <ECSlidingViewController/ECSlidingViewController.h>

@implementation AroundMeViewController

- (void)decorateCheckInButton {
    [self.checkInButton setTitleTextAttributes:
     @{UITextAttributeTextColor: [[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending ? [UIColor colorWithRed:51.0 / 250 green:140.0 / 250 blue:16.0 / 250 alpha:1.0] : [UIColor whiteColor],
       UITextAttributeTextShadowColor: [UIColor clearColor],
       UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, 0)],
       UITextAttributeFont: [UIFont systemFontOfSize:14.0]}
                                      forState:UIControlStateNormal];
}

- (void)toolbarDecorations {
    UIBarButtonItem *menuButton;
    menuButton = [self createLeftBarButton:@"arrow_west.png" actionSelector:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = menuButton;
}

- (void)decorateScroller {
    UIImage *maxBarImage = [UIImage imageNamed:@"highlight_distance_02_transparent.png"];
    UIImage *thumbImage = [UIImage imageNamed:@"highlight_distance.png"];
    UIImage *minBarImage = [UIImage imageNamed:@"highlight_distance_02_long.png"];

    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 0, 0);
    minBarImage = [minBarImage resizableImageWithCapInsets:insets];

    [self.distanceScroller setMaximumTrackImage:maxBarImage forState:UIControlStateNormal];
    [self.distanceScroller setMinimumTrackImage:minBarImage forState:UIControlStateNormal];
    [self.distanceScroller setThumbImage:thumbImage forState:UIControlStateNormal];
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
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
    self.navBarMenuItem.leftBarButtonItem = [self createLeftBarButton:@"mainmenu_button.png" actionSelector:@selector(tapMenu)];
    UIImageView *locImage = [[UIImageView alloc] initWithFrame:CGRectMake(85, 10, 20, 20)];
    locImage.image = [UIImage imageNamed:@"glyphicons_060_compass"];
    [self.navBar addSubview:locImage];
}

- (IBAction)backToMe:(id)sender {
    pinDropped = NO;
    [map animateToCameraPosition:[GMSCameraPosition cameraWithLatitude:map.myLocation.coordinate.latitude - 0.012 longitude:map.myLocation.coordinate.longitude zoom:13]];
    [self sliderValueChanged:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self decorateCheckInButton];
    [self decorateScroller];
    [self toolbarDecorations];

    loading = YES;

    crowdImagesHidden = NO;
    dropDownHidden = YES;
    appDelegate.shnergleThis = NO;
    [self menuButtonDecorations];

    if ([self.navBar respondsToSelector:@selector(setBarTintColor:)]) [self.navBar performSelector:@selector(setBarTintColor:) withObject:[UIColor colorWithRed:233.0 / 255 green:235.0 / 255 blue:240.0 / 255 alpha:1.0]];
    self.navBar.translucent = NO;
    
    id radius = [[NSUserDefaults standardUserDefaults] objectForKey:@"radius"];
    
    if (!radius) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:1.0] forKey:@"radius"];
    }else{
        self.distanceScroller.value = [radius floatValue];
        [self sliderValueChanged:nil];
    }
}

- (void)didFinishLoadingVenues:(NSArray *)response {
    @synchronized (self) {
        venues = response;
        [self.crowdCollection reloadData];
        loading = NO;
        [self.overlay hideToastActivity];
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
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"AroundMeMenu"];
    }
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    [self.slidingViewController setAnchorRightRevealAmount:230.0f];
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.navigationController.navigationBar.clipsToBounds = YES;
    self.navBar.clipsToBounds = YES;

    crowdImagesHidden = NO;

    [self addShadowLineRect:CGRectMake(0.0f, 70.0f, self.distanceScrollerView.frame.size.width, 1.0f) ToView:self.distanceScrollerView];

    [self addShadowLineRect:CGRectMake(0.0f, self.overlay.bounds.origin.y + (35 + 8), self.overlay.frame.size.width, 1.0f) ToView:self.overlay];

    appDelegate.activeVenue = nil;
    appDelegate.venueDetailsContent = nil;

    [self initMap];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
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
        [Request post:@"images/get" params:key delegate:self callback:@selector(didFinishDownloadingImages:forIndex:) userData:indexPath];
    }

    item.venueName.text = venues[indexPath.item][@"name"];
    item.venueName.font = [UIFont systemFontOfSize:11.0f];
    item.venueName.textColor = [UIColor whiteColor];

    if ([venues[indexPath.item][@"promotions"] intValue] > 0) {
        item.promotionIndicator.hidden = NO;
    } else {
        item.promotionIndicator.hidden = YES;
    }

    return item;
}

- (void)didFinishDownloadingImages:(UIImage *)response forIndex:(NSIndexPath *)index {
    if (response != nil && self.crowdCollection != nil && [self.crowdCollection numberOfItemsInSection:index.section] > index.item) {
        [self.crowdCollection reloadItemsAtIndexPaths:@[index]];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ToVenueSite"]) {
        appDelegate.activeVenue = venues[selectedVenue];
        [((VenueViewController *)[segue destinationViewController])setVenueInfo];
    } else if ([segue.identifier isEqualToString:@"CheckInFromAroundMe"]) {
        appDelegate.shareVenue = NO;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    selectedVenue = indexPath.item;
}

- (void)showOverlay {
    [[self overlay] showAnimated:126 animationDelay:0.2 animationDuration:0.5];
    crowdImagesHidden = NO;
}

- (void)hideOverlay {
    [[self overlay] hideAnimated:126 animationDuration:0.5 targetSize:350 contentView:[self overlay]];
    crowdImagesHidden = YES;
}

- (void)showDistanceScroller {
    if (self.distanceScrollerView.bounds.origin.y < 44) {
        [[self distanceScrollerView] showAnimated:44 animationDelay:0.0 animationDuration:0.5];
    }
}

- (void)hideDistanceScroller {
    if (self.distanceScrollerView.frame.origin.y > -64) {
        [[self distanceScrollerView] hideAnimated:44 animationDuration:0.8 targetSize:-64 contentView:[self distanceScrollerView]];
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    return YES;
}

- (IBAction)sliderValueChanged:(id)sender {
    [self.overlay makeToastActivity];
    [map clear];
    CLLocationCoordinate2D coord;
    if (pinDropped) {
        coord = pinDroppedLocation;
    } else {
        coord = map.myLocation.coordinate;
    }

    GMSCircle *mapCircle = [GMSCircle circleWithPosition:coord radius:self.distanceScroller.value * 1000];
    mapCircle.strokeColor = [UIColor orangeColor];
    mapCircle.strokeWidth = 5;

    /*
       =00ooo00oOOoOoOoo
       =Adam and Stian's magical coordinate substitution principle
       =ooOoOO000OOo00oOoo
     */
    CGFloat screenDistance = [map.projection pointsForMeters:(self.distanceScroller.value * 1000) atCoordinate:coord];
    CGPoint screenCenter = [map.projection pointForCoordinate:coord];
    CGPoint screenPoint = CGPointMake(screenCenter.x - screenDistance, screenCenter.y);
    CLLocationCoordinate2D realPoint = [map.projection coordinateForPoint:screenPoint];
    CGFloat distanceInDegrees = coord.longitude - realPoint.longitude;

    /*
       oo..
     */

    NSDictionary *params = @{@"my_lat": @(coord.latitude),
                             @"my_lon": @(coord.longitude),
                             @"distance": @(distanceInDegrees),
                             @"level": appDelegate.level,
                             @"around_me": @"true"};
    [Request post:@"venues/get" params:params delegate:self callback:@selector(didFinishLoadingVenues:)];

    mapCircle.map = map;
    
    //Prefs:
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:self.distanceScroller.value] forKey:@"radius"];


}

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    [map clear];
    pinDropped = true;
    pinDroppedLocation = coordinate;
    [self sliderValueChanged:nil];
}

- (void)tapMenu {
    [self.slidingViewController anchorTopViewTo:ECRight];
    [self showOverlay];
    [self hideDistanceScroller];
    crowdImagesHidden = NO;
    dropDownHidden = YES;
    [self drawerButtonImage:@"arrowDown.png"];
}

- (void)drawerButtonImage:(NSString *)imagenamed {
    [self.drawerCloseButton setImage:[UIImage imageNamed:imagenamed] forState:UIControlStateNormal];
}

- (IBAction)tapArrow:(id)sender {
    if (crowdImagesHidden) {
        [self showOverlay];
        [self hideDistanceScroller];
        [self drawerButtonImage:@"arrowDown.png"];
    } else {
        [self hideOverlay];
        [self showDistanceScroller];
        [self drawerButtonImage:@"arrowUp.png"];
    }
}

- (void)initMap {
    hasPositionLocked = NO;
    map = [[GMSMapView alloc] initWithFrame:CGRectMake(0, 44, self.view.bounds.size.width, 350)];
    map.myLocationEnabled = YES;
    map.delegate = self;
    [map addObserver:self forKeyPath:@"myLocation" options:NSKeyValueObservingOptionNew context:nil];
    [self.view addSubview:map];
    [self.view sendSubviewToBack:map];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (!hasPositionLocked) {
        if ([keyPath isEqualToString:@"myLocation"] && [object isKindOfClass:[GMSMapView class]]) {
            [map animateToCameraPosition:[GMSCameraPosition cameraWithLatitude:map.myLocation.coordinate.latitude - 0.012 longitude:map.myLocation.coordinate.longitude zoom:13]];
            hasPositionLocked = YES;
            [self sliderValueChanged:nil];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [map removeObserver:self forKeyPath:@"myLocation" context:nil];
    [map clear];
    [map stopRendering];
    [map removeFromSuperview];
    map = nil;
}

@end

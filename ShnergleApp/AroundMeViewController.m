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
#import "AppDelegate.h"
#import <Toast+UIView.h>
#import "PostRequest.h"
#import "VenueViewController.h"
#import "ImageCache.h"

@implementation AroundMeViewController


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)decorateCheckInButton {
    //check in button
    [self.checkInButton setTitleTextAttributes:
     @{UITextAttributeTextColor: [UIColor whiteColor],
       UITextAttributeTextShadowColor: [UIColor clearColor],
       UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, 0)],
       UITextAttributeFont: [UIFont systemFontOfSize:14.0]}
                                      forState:UIControlStateNormal];
}

- (void)toolbarDecorations {
    //TOOLBAR Additions
    UIBarButtonItem *menuButton;
    menuButton = [self createLeftBarButton:@"arrow_west.png" actionSelector:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = menuButton;

    //[[self navigationItem] setBackBarButtonItem:menuButton];
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

//workaround to get the custom back button to work
- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIBarButtonItem *)createLeftBarButton:(NSString *)imageName actionSelector:(SEL)actionSelector {
    UIImage *menuButtonImg = [UIImage imageNamed:imageName];

    UIButton *menuButtonTmp = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButtonTmp.frame = CGRectMake(280.0, 10.0, 22.0, 22.0);
    [menuButtonTmp setBackgroundImage:menuButtonImg forState:UIControlStateNormal];
    [menuButtonTmp addTarget:self action:actionSelector forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc]initWithCustomView:menuButtonTmp];
    return menuButton;
}

- (void)menuButtonDecorations {
    SEL actionSelector = @selector(tapMenu);
    NSString *imageName = @"mainmenu_button.png";


    UIBarButtonItem *menuButton;
    menuButton = [self createLeftBarButton:imageName actionSelector:actionSelector];


    self.navBarMenuItem.leftBarButtonItem = menuButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self decorateCheckInButton];
    [self decorateScroller];
    [self toolbarDecorations];

    //CROWD stuff
    [[self crowdCollection] setDataSource:self];
    [[self crowdCollection] setDelegate:self];
    //[self createTitleButton];

    loading = YES;


    //[NSThread detachNewThreadSelector:@selector(makeRequest) toTarget:self withObject:nil];
    [self makeRequest];
    crowdImagesHidden = NO;
    dropDownHidden = YES;


    [self menuButtonDecorations];
}

- (void)makeRequest {
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    [[[PostRequest alloc] init]exec:@"venues/get" params:[NSString stringWithFormat:@"facebook_id=%@", appDelegate.facebookId] delegate:self callback:@selector(didFinishLoadingVenues:)];
}

- (void)didFinishLoadingVenues:(NSArray *)response {
    NSLog(@"%@",response);
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    appDelegate.aroundVenues = response;
    [self.crowdCollection reloadData];
    loading = NO;
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
    //Make it hidden whenever we navigate back to the view as well.
    dropDownHidden = YES;
    crowdImagesHidden = NO;
    //THE SANDWICH MENU SYSTEM (ECSlidingViewController)
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"AroundMeMenu"];
    }
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    [self.slidingViewController setAnchorRightRevealAmount:230.0f];

    // Shadow for sandwich system
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;

    //Remove shadows for navbar
    self.navigationController.navigationBar.clipsToBounds = YES;
    self.navBar.clipsToBounds = YES;

    crowdImagesHidden = NO;

    [self addShadowLineRect:CGRectMake(0.0f, 70.0f, self.distanceScrollerView.frame.size.width, 1.0f) ToView:self.distanceScrollerView];

    [self addShadowLineRect:CGRectMake(0.0f, self.overlay.bounds.origin.y + 35, self.overlay.frame.size.width, 1.0f) ToView:self.overlay];

    //self.overlay.layer.shouldRasterize = YES;

    [self initMap];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    return appDelegate.aroundVenues ? [appDelegate.aroundVenues count] : 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    CrowdItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];

    /*SHADOW AROUND OBJECTS*/
    /*
       item.layer.masksToBounds = NO;
       item.layer.borderColor = [UIColor grayColor].CGColor;
       item.layer.borderWidth = 1.5f;
       item.layer.contentsScale = [UIScreen mainScreen].scale;
       item.layer.shadowOpacity = 0.5f;
       item.layer.shadowRadius = 3.0f;
       item.layer.shadowOffset = CGSizeZero;
       item.layer.shadowPath = [UIBezierPath bezierPathWithRect:item.bounds].CGPath;
       //item.layer.shouldRasterize = YES;
     */
    /* Here we can set the elements of the crowdItem (the cell) in the cellview */
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    //[[[PostRequest alloc]init]exec:@"images/get" params:[NSString stringWithFormat:@"entity=post&entity_id=0&facebook_id=%@",appDelegate.facebookId] delegate:self callback:@selector(didFinishDownloadingImages:forItem:) type:@"image" item:item];
    [[[ImageCache alloc]init]get:@"venue" identifier:[appDelegate.aroundVenues[indexPath.item][@"id"] stringValue] delegate:self callback:@selector(didFinishDownloadingImages:forItem:) item:item];

    [[item venueName] setText:appDelegate.aroundVenues[indexPath.item][@"name"]];

    item.venueName.font = [UIFont systemFontOfSize:11.0f];

    item.venueName.textColor = [UIColor whiteColor];

    //Turn the indicator on or off:
    if (appDelegate.aroundVenues[indexPath.item][@"promotion"] != nil) {
        item.promotionIndicator.hidden = NO;
    } else {
        item.promotionIndicator.hidden = YES;
    }

    return item;
}

- (void)didFinishDownloadingImages:(UIImage *)response forItem:(CrowdItem *)item {
    [[item crowdImage] setImage:response];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if ([segue.identifier isEqualToString:@"ToVenueSite"]) {
        [(VenueViewController *)segue.destinationViewController setVenue : appDelegate.aroundVenues[selectedVenue]];
    }
}

- (void)collectionView:(UICollectionView *)collectionView
    didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
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
        [[self distanceScrollerView]hideAnimated:44 animationDuration:0.8 targetSize:-64 contentView:[self distanceScrollerView]];
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    return YES;
}

- (IBAction)sliderValueChanged:(id)sender {
    /*
       Here we can query the database for venues within the radius
       given in self.distanceScroller.value (this is in metres)
       Would have to translate into coordinates?
     */
    [self.mapView clear ];


    CLLocationCoordinate2D coord;
    if (pinDropped) {
        coord = pinDroppedLocation;
    } else {
        coord = self.mapView.myLocation.coordinate;
    }

    //Creates a circle on the map with a radius in metres
    GMSCircle *mapCircle = [GMSCircle circleWithPosition:coord radius:self.distanceScroller.value * 1000];
    mapCircle.strokeColor = [UIColor orangeColor];
    mapCircle.strokeWidth = 5;

    mapCircle.map = self.mapView;
}

- (void)mapView:(GMSMapView *)mapView
    didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    [self.mapView clear];
    /*
       CLLocationCoordinate2D position = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude);
       GMSMarker *marker = [GMSMarker markerWithPosition:position];
       marker.title = @"Dropped Pin";
       marker.map = self.mapView;
     */
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
    _mapView = [[GMSMapView alloc] initWithFrame:CGRectMake(0, 44, self.view.bounds.size.width, self.view.bounds.size.height - 60)];
    _mapView.myLocationEnabled = YES;
    _mapView.delegate = self;
    [_mapView addObserver:self forKeyPath:@"myLocation" options:NSKeyValueObservingOptionNew context:nil];
    [self.view addSubview:_mapView];
    [self.view sendSubviewToBack:_mapView];
    

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    // How it works:
    // Whenever position changes, this method is run. It then changes the camera to point to the current position, minus a small latitude (to make the map position center in the top part of our Arou nd Me view). The zoom level is an average level of detail for a few blocks.

    //Make sure it is only run once:
    if (!hasPositionLocked) {
        if ([keyPath isEqualToString:@"myLocation"] && [object isKindOfClass:[GMSMapView class]]) {
            [_mapView animateToCameraPosition:[GMSCameraPosition cameraWithLatitude:_mapView.myLocation.coordinate.latitude - 0.010
                                                                          longitude:_mapView.myLocation.coordinate.longitude
                                                                               zoom:13]];
            hasPositionLocked = YES;
            AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
            appDelegate.shareImageLat = [NSString stringWithFormat:@"%f",self.mapView.myLocation.coordinate.latitude];
            appDelegate.shareImageLon = [NSString stringWithFormat:@"%f",self.mapView.myLocation.coordinate.longitude];
            NSLog(@"%@", appDelegate.shareImageLat);
            NSLog(@"%@", appDelegate.shareImageLon);
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_mapView removeObserver:self forKeyPath:@"myLocation" context:nil];
    [_mapView clear];
    [_mapView stopRendering];
    [_mapView removeFromSuperview];
    _mapView = nil;
}

@end

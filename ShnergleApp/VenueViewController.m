//
//  VenueViewController.m
//  ShnergleApp
//
//  Created by Stian Johansen on 3/22/13.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "VenueViewController.h"
#import "CrowdItem.h"
#import "PromotionView.h"
#import "VenueGalleryViewController.h"
#import "AppDelegate.h"

@implementation VenueViewController


- (void)setTitle:(NSString *)title {
    titleHeader = title;
}

- (void)setHeaderTitle:(NSString *)headerTitle andSubtitle:(NSString *)headerSubtitle {
    CGRect headerTitleSubtitleFrame = CGRectMake(0, 0, 200, 44);
    UIView *headerTitleSubtitleView = [[UILabel alloc] initWithFrame:headerTitleSubtitleFrame];
    headerTitleSubtitleView.backgroundColor = [UIColor clearColor];
    headerTitleSubtitleView.autoresizesSubviews = YES;

    CGRect titleFrame = CGRectMake(0, 2, 200, 24);
    UILabel *titleView2 = [[UILabel alloc] initWithFrame:titleFrame];
    titleView2.backgroundColor = [UIColor clearColor];
    titleView2.font = [UIFont fontWithName:@"Roboto-Regular" size:20.0];
    titleView2.textAlignment = NSTextAlignmentCenter;
    titleView2.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
    titleView2.shadowColor = [UIColor darkGrayColor];
    titleView2.shadowOffset = CGSizeMake(0, 0);
    titleView2.text = headerTitle;
    titleView2.adjustsFontSizeToFitWidth = YES;
    [headerTitleSubtitleView addSubview:titleView2];

    CGRect subtitleFrame = CGRectMake(0, 24, 200, 44 - 24);
    UILabel *subtitleView2 = [[UILabel alloc] initWithFrame:subtitleFrame];
    subtitleView2.backgroundColor = [UIColor clearColor];
    subtitleView2.font = [UIFont fontWithName:@"Roboto-Regular" size:12.0];
    subtitleView2.textAlignment = NSTextAlignmentCenter;
    subtitleView2.textColor = [UIColor colorWithRed:51.0 / 250 green:140.0 / 250 blue:16.0 / 250 alpha:1.0];
    subtitleView2.shadowColor = [UIColor clearColor];
    subtitleView2.shadowOffset = CGSizeMake(0, 0);
    subtitleView2.text = headerSubtitle;
    subtitleView2.adjustsFontSizeToFitWidth = YES;
    [headerTitleSubtitleView addSubview:subtitleView2];

    headerTitleSubtitleView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
                                                UIViewAutoresizingFlexibleRightMargin |
                                                UIViewAutoresizingFlexibleTopMargin |
                                                UIViewAutoresizingFlexibleBottomMargin);

    self.navigationItem.titleView = headerTitleSubtitleView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.checkInButton setTitleTextAttributes:
     @{UITextAttributeTextColor: [UIColor whiteColor],
       UITextAttributeTextShadowColor: [UIColor clearColor],
       UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, 0)],
       UITextAttributeFont: [UIFont fontWithName:@"Roboto" size:14.0]}
                                      forState:UIControlStateNormal];

    textViewOpen = false;
    [[self crowdCollectionV] setDataSource:self];
    [[self crowdCollectionV] setDelegate:self];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.images = @[@"1230.png",@"1645.jpg",@"1655.jpg",@"1700.jpg",@"1730.jpg",@"1745.jpg",@"1930.jpg",@"2012.jpg",@"2023.jpg",@"2035.jpg",@"2046.jpg",@"2105.jpg",@"2107.jpg",@"2108.jpg",@"2109.jpg",@"2115.jpg",@"2128.jpg",@"2146.jpg",@"2207.jpg",@"2210.jpg",@"2215.jpg",@"2223.jpg",@"2235.jpg",@"2250.jpg",@"2308.jpg",@"2336.jpg",@"2350.jpg",@"2353.jpg",@"0013.jpg",@"0030.jpg",@"0047.jpg",@"0050.jpg"];

    appDelegate.timestamps = @[@"00:50",@"00:47",@"00:30",@"00:13",@"23:53",@"23:50",@"23:36",@"23:08",@"22:50",@"22:35",@"22:23",@"22:15",@"22:10",@"22:07",@"21:46",@"21:28",@"21:15",@"21:09",@"21:08",@"21:07",@"21:05",@"20:46",@"20:35",@"20:23",@"20:12",@"19:30",@"17:45",@"17:30",@"17:00",@"16:55",@"16:45",@"12:30",];
    
    #warning "demo venue images are reversed in code, don't worry about it. "
    appDelegate.images = [[appDelegate.images reverseObjectEnumerator] allObjects];

    promotionTitle = @"Tonight's special offer";
    promotionExpiry = @"Expires at 11 pm";
    promotionBody = @"3-4-2 on tequila doubles!!";

    [self displayTextView];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    return [appDelegate.images count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    CrowdItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    /* Here we can set the elements of the crowdItem (the cell) in the cellview */
    [[item crowdImage] setImage:[UIImage imageNamed:appDelegate.images[indexPath.item]]];
    [[item venueName] setText:appDelegate.timestamps[indexPath.item]];
    [[item venueName] setTextColor:[UIColor whiteColor]];
    [[item venueName] setFont:[UIFont fontWithName:@"Roboto" size:11.0]];
    //[[item venueName] setText:appDelegate.venueNames[indexPath.item]];


    /*SHADOW AROUND OBJECTS
       item.layer.masksToBounds = NO;
       item.layer.borderColor = [UIColor grayColor].CGColor;
       item.layer.borderWidth = 1.0f;
       item.layer.contentsScale = [UIScreen mainScreen].scale;
       item.layer.shadowOpacity = 0.6f;
       item.layer.shadowRadius = 2.0f;
       item.layer.shadowOffset = CGSizeZero;
       item.layer.shadowPath = [UIBezierPath bezierPathWithRect:item.bounds].CGPath;
       item.layer.shouldRasterize = YES;
     */


    return item;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)displayTextView {
    if (!textViewOpen) {
        _overlayView = [[NSBundle mainBundle] loadNibNamed:@"OverlayText" owner:self options:nil][0];
        //Get screen height:
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenHeight = screenRect.size.height;


        _overlayView.frame = CGRectMake(_overlayView.bounds.origin.x, screenHeight - 70, _overlayView.bounds.size.width, _overlayView.bounds.size.height);
        _overlayView.clipsToBounds = NO;
        [self configureMapWithLat:51.513930 longitude:-0.158198];
        [self.view addSubview:_overlayView];
        textViewOpen = true;
    }
}

- (void)instantHideTextView {
}

- (void)configureMapWithLat:(CLLocationDegrees)lat longitude:(CLLocationDegrees)lon {
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:lat
                                                            longitude:lon
                                                                 zoom:13];
    self.overlayView.venueMap.camera = camera;

    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(lat, lon);
    marker.title = @"";
    marker.snippet = @"";
    marker.map = self.overlayView.venueMap;
    self.overlayView.venueMap.userInteractionEnabled = FALSE;
}

// SCROLLHIDE
- (void)hideOverlay {
    if (hidden) return;

    hidden = YES;

    [self.overlayView setTabBarHidden:YES
                             animated:YES];

    /*[self.navigationController setNavigationBarHidden:YES
       animated:YES];*/
}

- (void)showOverlay {
    if (!hidden) return;

    hidden = NO;

    [self.overlayView setTabBarHidden:NO
                             animated:YES];

    /*[self.navigationController setNavigationBarHidden:NO
       animated:YES];*/
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    startContentOffset = lastContentOffset = scrollView.contentOffset.y;
    //NSLog(@"scrollViewWillBeginDragging: %f", scrollView.contentOffset.y);
}

/*
   - (void)scrollViewDidScroll:(UIScrollView *)scrollView
   {
   CGFloat currentOffset = scrollView.contentOffset.y;
   CGFloat differenceFromStart = startContentOffset - currentOffset;
   CGFloat differenceFromLast = lastContentOffset - currentOffset;
   lastContentOffset = currentOffset;



   if((differenceFromStart) < 0)
   {
   // scroll up
   if(scrollView.isTracking && (abs(differenceFromLast)>1))
   [self hideOverlay];
   }
   else {
   if(scrollView.isTracking && (abs(differenceFromLast)>1))
   [self showOverlay];
   }

   }
 */

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    [self showOverlay];
    return YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[super viewWillAppear:animated];
    //self.navigationItem.hidesBackButton = NO;
    /*[self.navigationController setNavigationBarHidden:hidden
       animated:YES];*/

    //self.navigationItem.hidesBackButton = NO;
    hidden = YES;

    self.navigationController.navigationBarHidden = NO;
    //AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    //[self setHeaderTitle:appDelegate.venueNames[indexPath.item]  andSubtitle:@"subtitle"];

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"TESTING" message:@"Please select status of venue in relation to thyself." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Normal", @"Following", @"Staff", @"Manager", nil];
    [alert show];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.overlayView setTabBarHidden:hidden
                             animated:NO];
    
    self.overlayView.offerContents.text = promotionBody;
    self.overlayView.offerHeadline.text = promotionTitle;
    self.overlayView.offerCount.text = promotionExpiry;
    
    self.overlayView.offerCount.font = [UIFont fontWithName:@"Roboto" size:9];
    self.overlayView.offerHeadline.font = [UIFont fontWithName:@"Roboto" size:11];
    self.overlayView.offerContents.font = [UIFont fontWithName:@"Roboto" size:22];
    self.overlayView.offerContents.textColor = [UIColor whiteColor];
    self.overlayView.offerContents.textAlignment = NSTextAlignmentCenter;
    
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)goToPromotionView {
    PromotionView *promotionView = [[NSBundle mainBundle] loadNibNamed:@"PromotionView" owner:self options:nil][0];
    [promotionView setpromotionTitle:promotionTitle];
    [promotionView setpromotionBody:promotionBody];
    [promotionView setpromotionExpiry:promotionExpiry];
    
    [self.navigationController pushViewController:promotionView animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if ([segue.identifier isEqualToString:@"ToGallery"]) {
        [segue.destinationViewController setTitle:self.navigationItem.title];
        [(VenueGalleryViewController *)segue.destinationViewController setImages : appDelegate.images index : selectedImage];
    }
}

- (void)         collectionView:(UICollectionView *)collectionView
    didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    selectedImage = indexPath.row;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    switch (buttonIndex) {
        case 0:
            appDelegate.venueStatus = None;
            [self goBack];
            break;
        case 1:
            appDelegate.venueStatus = Default;
            [self setHeaderTitle:titleHeader andSubtitle:@"Tap to Follow"];
            break;
        case 2:
            appDelegate.venueStatus = Following;
            [self setHeaderTitle:titleHeader andSubtitle:@"Following"];
            break;
        case 3:
            appDelegate.venueStatus = Staff;
            [self setHeaderTitle:titleHeader andSubtitle:@"Staff"];
            break;
        case 4:
            appDelegate.venueStatus = Manager;
            [self setHeaderTitle:titleHeader andSubtitle:@"Manager"];
            break;
    }
    [_overlayView didAppear];
}

@end

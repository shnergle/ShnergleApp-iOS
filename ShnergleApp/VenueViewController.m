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
#import "AddPromotionsViewController.h"
#import "VenueGalleryViewController.h"
#import "Request.h"
#import "PhotoLocationViewController.h"
#import <NSDate+TimeAgo/NSDate+TimeAgo.h>
#import <Toast/Toast+UIView.h>
#import <QuartzCore/QuartzCore.h>
#import "UIViewController+CheckIn.h"

@implementation VenueViewController

- (void)setVenueInfo {
    titleHeader = appDelegate.activeVenue[@"name"];
    venueLat = [appDelegate.activeVenue[@"lat"] doubleValue];
    venueLon = [appDelegate.activeVenue[@"lon"] doubleValue];
    summaryContent = [NSString stringWithFormat:@"%@", appDelegate.activeVenue[@"tonight"]];
    summaryHeadline = [NSString stringWithFormat:@"Tonight at %@", appDelegate.activeVenue[@"name"]];
}

- (void)setHeaderTitle:(NSString *)headerTitle andSubtitle:(NSString *)headerSubtitle {
    CGRect headerTitleSubtitleFrame = CGRectMake(0, 0, 200, 44);
    UIView *headerTitleSubtitleView = [[UILabel alloc] initWithFrame:headerTitleSubtitleFrame];
    headerTitleSubtitleView.backgroundColor = [UIColor clearColor];
    headerTitleSubtitleView.autoresizesSubviews = YES;
    CGRect titleFrame = CGRectMake(0, 2, 200, 24);
    UILabel *titleView2 = [[UILabel alloc] initWithFrame:titleFrame];
    titleView2.backgroundColor = [UIColor clearColor];
    titleView2.font = [UIFont systemFontOfSize:20.0];
    titleView2.textAlignment = NSTextAlignmentCenter;
    titleView2.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
    titleView2.shadowColor = [UIColor darkGrayColor];
    titleView2.shadowOffset = CGSizeMake(0, 0);
    titleView2.text = headerTitle;
    titleView2.adjustsFontSizeToFitWidth = YES;
    [headerTitleSubtitleView addSubview:titleView2];

    CGRect subtitleFrame = CGRectMake(25, 0, 150, 68);
    UILabel *subtitleView2 = [[UILabel alloc] initWithFrame:subtitleFrame];
    subtitleView2.backgroundColor = [UIColor clearColor];
    subtitleView2.font = [UIFont systemFontOfSize:12.0];
    subtitleView2.textAlignment = NSTextAlignmentCenter;
    subtitleView2.textColor = [UIColor colorWithRed:51.0 / 250 green:140.0 / 250 blue:16.0 / 250 alpha:1.0];
    subtitleView2.shadowColor = [UIColor clearColor];
    subtitleView2.shadowOffset = CGSizeMake(0, 0);
    subtitleView2.text = headerSubtitle;
    subtitleView2.adjustsFontSizeToFitWidth = YES;
    subtitleView2.userInteractionEnabled = YES;
    [headerTitleSubtitleView addSubview:subtitleView2];

    headerTitleSubtitleView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
                                                UIViewAutoresizingFlexibleRightMargin |
                                                UIViewAutoresizingFlexibleTopMargin |
                                                UIViewAutoresizingFlexibleBottomMargin);

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToFollow)];
    [subtitleView2 addGestureRecognizer:tapGestureRecognizer];

    self.navigationItem.titleView = headerTitleSubtitleView;
    self.navigationItem.titleView.userInteractionEnabled = YES;
}

- (void)tapToFollow {
    if (appDelegate.venueStatus != Default) return;

    [self.view makeToastActivity];

    following = !following;
    if (following) {
        [self setHeaderTitle:titleHeader andSubtitle:@"Following"];
    } else {
        [self setHeaderTitle:titleHeader andSubtitle:@"Tap to Follow"];
    }
    NSDictionary *params = @{@"venue_id": appDelegate.activeVenue[@"id"],
                             @"following": following ? @"true" : @"false"};
    [Request post:@"venue_followers/set" params:params callback:^(id response) {
        [self.view hideToastActivity];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    following = [appDelegate.activeVenue[@"following"] integerValue] == 0 ? NO : YES;
    [Request removeImage:@{@"entity": @"image", @"entity_id": @"toShare"}];

    if (!appDelegate.activeVenue[@"tonight"]) {
        summaryContent = @"";
    } else {
        summaryContent = appDelegate.activeVenue[@"tonight"];
    }

    if (appDelegate.activeVenue[@"headline"]) {
        summaryHeadline = appDelegate.activeVenue[@"headline"];
    }

    if (appDelegate.activeVenue[@"name"]) {
        titleHeader = appDelegate.activeVenue[@"name"];
    }

    [self.checkInButton setTitleTextAttributes:
     @{NSForegroundColorAttributeName: [UIColor blackColor],
       NSFontAttributeName: [UIFont systemFontOfSize:14.0]}
                                      forState:UIControlStateNormal];

    textViewOpen = false;
    self.crowdCollectionV.dataSource = self;
    self.crowdCollectionV.delegate = self;

    self.crowdCollectionV.alwaysBounceVertical = YES;

    promotionTitle = @"";
    promotionExpiry = @"";
    promotionBody = @"No Promotion Active";
    promotionUntil = @"";
    promotionLevel = @"";

    [self displayTextView];

    [self configureMapWithLat:[appDelegate.activeVenue[@"lat"] doubleValue] longitude:[appDelegate.activeVenue[@"lon"] doubleValue]];

    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(startRefresh:)
             forControlEvents:UIControlEventValueChanged];
    [self.crowdCollectionV addSubview:refreshControl];

    [overlayView.scrollView setScrollsToTop:NO];
    [self.crowdCollectionV setScrollsToTop:YES];

    [Request post:@"venue_views/set" params:@{@"venue_id": appDelegate.activeVenue[@"id"]} callback:^(id response) {
        [self.view hideToastActivity];
    }];
}

- (NSString *)levelName:(NSInteger)level {
    switch (level) {
        case 1:
            return @"Explorers";
        case 2:
            return @"Scouts";
        case 3:
            return @"Shnerglers";
        default:
            return @"";
    }
}

- (NSString *)getDateFromUnixFormatNotTimeAgo:(id)unixFormat {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[unixFormat integerValue]];
    return [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
}

- (void)startRefresh:(id)sender {
    [self getPosts];
}

- (void)addShadowLineRect:(CGRect)shadeRect ToView:(UIView *)view {
    CALayer *topBorder = [CALayer layer];
    topBorder.frame = shadeRect;
    topBorder.backgroundColor = [UIColor lightGrayColor].CGColor;
    [view.layer addSublayer:topBorder];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return posts ? [posts count] : 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    CrowdItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];

    NSDictionary *key = @{@"entity": @"post",
                          @"entity_id": posts[indexPath.item][@"id"]};
    item.index = indexPath.item;
    item.crowdImage.backgroundColor = [UIColor lightGrayColor];
    if (!(item.crowdImage.image = [Request getImage:key])) {
        [Request post:@"images/get" params:key callback:^(id response) {
            if (posts != nil) {
                if (indexPath.item == 0) {
                    NSDictionary *key = @{@"entity": @"post",
                                          @"entity_id": posts[0][@"id"]};
                    [Request setImage:@{@"entity": @"image", @"entity_id": @"toShare"} image:[Request getImage:key]];
                    [Request setImage:@{@"entity": @"venue", @"entity_id": appDelegate.activeVenue[@"id"]} image:[Request getImage:key]];
                }

                if (response != nil && self.crowdCollectionV != nil && [self.crowdCollectionV numberOfItemsInSection:indexPath.section] > indexPath.item) {
                    @try {
                        [self.crowdCollectionV reloadItemsAtIndexPaths:@[indexPath]];
                    } @catch (NSException *exception) {
                    }
                }
            }
        }];
    }

    item.venueName.text = [self getDateFromUnixFormat:posts[indexPath.item][@"time"]];
    item.venueName.textColor = [UIColor whiteColor];
    item.venueName.font = [UIFont systemFontOfSize:11];

    return item;
}

- (void)displayTextView {
    if (!textViewOpen) {
        overlayView = [[NSBundle mainBundle] loadNibNamed:@"OverlayText" owner:self options:nil][0];
        CGRect screenRect = [UIScreen mainScreen].bounds;
        CGFloat screenHeight = screenRect.size.height;

        overlayView.frame = CGRectMake(overlayView.bounds.origin.x, screenHeight - 80, overlayView.bounds.size.width, screenHeight - 75);
        overlayView.clipsToBounds = NO;
        [self.view addSubview:overlayView];
        textViewOpen = true;

        [self addShadowLineRect:CGRectMake(0.0f, overlayView.bounds.origin.y, overlayView.bounds.size.width, 1.0f) ToView:overlayView];
        [self addShadowLineRect:CGRectMake(0.0f, overlayView.bounds.origin.y + 63, overlayView.bounds.size.width, 1.0f) ToView:overlayView];
    }
}

- (void)configureMapWithLat:(CLLocationDegrees)lat longitude:(CLLocationDegrees)lon {
    MKMapPoint point = MKMapPointForCoordinate(CLLocationCoordinate2DMake(lat, lon));
    MKCoordinateRegion region = MKCoordinateRegionForMapRect(MKMapRectMake(point.x, point.y, overlayView.venueMap.frame.size.width * 50, overlayView.venueMap.frame.size.height * 50));
    overlayView.venueMap.region = region;
    overlayView.venueMap.centerCoordinate = CLLocationCoordinate2DMake(lat, lon);
    MKPointAnnotation *pin = [[MKPointAnnotation alloc] init];
    pin.coordinate = CLLocationCoordinate2DMake(lat, lon);
    [overlayView.venueMap addAnnotation:pin];
    overlayView.venueMap.userInteractionEnabled = NO;
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    return YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    NSDictionary *params = @{@"venue_id": appDelegate.activeVenue[@"id"],
                             @"level": appDelegate.level,
                             @"from_time": @([Request time:NO]),
                             @"until_time": @([Request time:YES])};
    [Request post:@"promotions/get" params:params callback:^(id response) {
        if ([response respondsToSelector:@selector(objectForKeyedSubscript:)]) {
            appDelegate.activePromotion = response;
            appDelegate.canRedeem = [response[@"own_redemptions"] integerValue] == 0;
            promotionBody = response[@"description"];
            promotionTitle = response[@"title"];
            promotionExpiry = ([response[@"maximum"] integerValue] == 0 || response[@"maximum"] == nil) ? [NSString stringWithFormat:@"%@ claimed", response[@"redemptions"]] : [NSString stringWithFormat:@"%@/%@ claimed", response[@"redemptions"], response[@"maximum"]];
            promotionUntil = [response[@"end"] integerValue] > 0 ? [NSString stringWithFormat:@"Expires %@", [NSDateFormatter localizedStringFromDate:[NSDate dateWithTimeIntervalSince1970:[response[@"end"] integerValue]] dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle]] : @"";
            promotionLevel = ([response[@"level"] integerValue] == 0 || response[@"level"] == nil) ? @"" : [NSString stringWithFormat:@"%@ only", [self levelName:[response[@"level"] integerValue]]];
            overlayView.tapPromotion.enabled = YES;
        } else {
            promotionBody = @"No Promotion Active";
            promotionTitle = @"";
            promotionExpiry = @"";
            promotionUntil = @"";
            promotionLevel = @"";
            overlayView.tapPromotion.enabled = NO;
        }

        [self setPromoContentTo:promotionBody promoHeadline:promotionTitle promoExpiry:promotionExpiry];
    }];

    if ([appDelegate.activeVenue[@"manager"] integerValue] == 1 && [appDelegate.activeVenue[@"verified"] integerValue] == 0) {
        [self setStatus:UnverifiedManager];
    } else if ([appDelegate.activeVenue[@"staff"] integerValue] == 1) {
        [self setStatus:Staff];
    } else if ([appDelegate.activeVenue[@"manager"] integerValue] == 1 && [appDelegate.activeVenue[@"verified"] integerValue] == 1) {
        [self setStatus:Manager];
    } else {
        [self setStatus:Default];
    }

    man = [[CLLocationManager alloc] init];
    man.delegate = self;
    man.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    [man startUpdatingLocation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [man stopUpdatingLocation];
    man = nil;
}

- (void)setPromoContentTo:(NSString *)promoContent promoHeadline:(NSString *)promoHeadline promoExpiry:(NSString *)promoExpiry {
    overlayView.promotionContents.text = promoContent;
    overlayView.promotionHeadline.text = promoHeadline;
    overlayView.promotionCount.text = promoExpiry;
    overlayView.promotionCount.font = [UIFont systemFontOfSize:9];
    overlayView.promotionCount.textAlignment = NSTextAlignmentCenter;
    overlayView.promotionCount.textColor = [UIColor whiteColor];
    overlayView.promotionHeadline.font = [UIFont systemFontOfSize:11];
    overlayView.promotionHeadline.textAlignment = NSTextAlignmentCenter;
    overlayView.promotionHeadline.textColor = [UIColor whiteColor];
    overlayView.promotionContents.font = [UIFont systemFontOfSize:22];
    overlayView.promotionContents.textColor = [UIColor whiteColor];
    overlayView.promotionContents.textAlignment = NSTextAlignmentCenter;
}

- (void)getPosts {
    [Request post:@"posts/get" params:@{@"venue_id": appDelegate.activeVenue[@"id"]} callback:^(id response) {
        @synchronized(self) {
            posts = response;
            [self.crowdCollectionV reloadData];
            [refreshControl endRefreshing];
            if ([posts count] > 0 && posts[0] != nil) {
                NSDictionary *key = @{@"entity": @"post",
                                      @"entity_id": posts[0][@"id"]};
                [Request setImage:@{@"entity": @"image", @"entity_id": @"toShare"} image:[Request getImage:key]];
            } else {
                self.crowdCollectionV.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"No_Activity_Background"]];
            }
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    appDelegate.redeeming = nil;

    [overlayView setTabBarHidden:YES animated:NO];
    [self setPromoContentTo:promotionBody promoHeadline:promotionTitle promoExpiry:promotionExpiry];
    overlayView.summaryContentTextField.text = [NSString stringWithFormat:@"%@", appDelegate.activeVenue[@"tonight"]];
    overlayView.summaryHeadlineTextField.text = [NSString stringWithFormat:@"%@", appDelegate.activeVenue[@"headline"]];

    [self getPosts];
    [overlayView didAppear];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [overlayView.scrollView setContentOffset:CGPointZero animated:YES];
    posts = nil;
    [self.crowdCollectionV reloadData];
}

- (void)goToPromotionView {
    if ([appDelegate.activeVenue[@"verified"] integerValue] == 1 && appDelegate.venueStatus != Manager && appDelegate.venueStatus != Staff) {
        PromotionView *promotionView = [[NSBundle mainBundle] loadNibNamed:@"PromotionView" owner:self options:nil][0];
        [promotionView setpromotionTitle:promotionTitle];
        [promotionView setpromotionBody:promotionBody];
        [promotionView setpromotionExpiry:promotionUntil];
        [promotionView setpromotionClaimed:promotionExpiry];
        [promotionView setpromotionLevel:promotionLevel];
        [self.navigationController pushViewController:promotionView animated:YES];
    } else {
        AddPromotionsViewController *promotionView = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectPromotionsViewController"];
        [self.navigationController pushViewController:promotionView animated:YES];
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([@"ToGallery" isEqualToString : identifier] && !((CrowdItem *)sender).crowdImage.image) return NO;
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([@"ToGallery" isEqualToString : segue.identifier]) {
        ((VenueGalleryViewController *)segue.destinationViewController).navigationItem.title = titleHeader;
        [(VenueGalleryViewController *)segue.destinationViewController setImage:selectedPost of:posts];
    }
}

- (void)reloadOverlay {
    overlayView.claimVenueButton.hidden = YES;
    overlayView.intentionHeightConstraints.constant = -20;
    [overlayView updateConstraints];
    [self setHeaderTitle:titleHeader andSubtitle:@"Manager (unverified)"];
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    selectedPost = indexPath.item;
    appDelegate.shareActivePostId = posts[selectedPost][@"id"];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    selectedPost = indexPath.item;
    appDelegate.shareActivePostId = posts[selectedPost][@"id"];
}

- (void)setStatus:(VENUE_STATUS)status {
    appDelegate.venueStatus = status;
    switch (status) {
        case Default:
            if (following) {
                [self setHeaderTitle:titleHeader andSubtitle:@"Following"];
            } else {
                [self setHeaderTitle:titleHeader andSubtitle:@"Tap to Follow"];
            }
            break;
        case Staff:
            [self setHeaderTitle:titleHeader andSubtitle:@"Staff"];
            break;
        case Manager:
            [self setHeaderTitle:titleHeader andSubtitle:@"Manager"];
            break;
        case UnverifiedManager:
            [self setHeaderTitle:titleHeader andSubtitle:@"Manager (unverified)"];
    }
}

- (NSString *)getDateFromUnixFormat:(id)unixFormat {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[unixFormat integerValue]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"ccc H:mm";
    return [date timeAgoWithLimit:86400 dateFormatter:dateFormatter];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    BOOL on = [((CLLocation *)locations.lastObject)distanceFromLocation :[[CLLocation alloc] initWithLatitude:[appDelegate.activeVenue[@"lat"] doubleValue] longitude:[appDelegate.activeVenue[@"lon"] doubleValue]]] <= 111;
    self.checkInButton.enabled = on;

    [self.checkInButton setTitleTextAttributes:
     @{NSForegroundColorAttributeName: (on ? [UIColor colorWithRed:51.0 / 250 green:140.0 / 250 blue:16.0 / 250 alpha:1.0] : [UIColor blackColor]),
       NSFontAttributeName: [UIFont systemFontOfSize:14.0]}
                                      forState:UIControlStateNormal];
}

@end

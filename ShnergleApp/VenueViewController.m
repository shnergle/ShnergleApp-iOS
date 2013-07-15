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
#import "PostRequest.h"
#import "ImageCache.h"
#import "PhotoLocationViewController.h"
#import <NSDate+TimeAgo/NSDate+TimeAgo.h>
#import <Toast/Toast+UIView.h>

@implementation VenueViewController

- (void)setVenue:(NSDictionary *)venue {
    titleHeader = venue[@"name"];
    venueLat = [venue[@"lat"] doubleValue];
    venueLon = [venue[@"lon"] doubleValue];
    summaryContent = [NSString stringWithFormat:@"%@", venue[@"tonight"]];
    summaryHeadline = [NSString stringWithFormat:@"Tonight at %@", venue[@"name"]];

    appDelegate.activeVenue = venue;
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

    CGRect subtitleFrame = CGRectMake(0, 24, 200, 20);
    UILabel *subtitleView2 = [[UILabel alloc] initWithFrame:subtitleFrame];
    subtitleView2.backgroundColor = [UIColor clearColor];
    subtitleView2.font = [UIFont systemFontOfSize:12.0];
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

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToFollow)];
    [headerTitleSubtitleView addGestureRecognizer:tapGestureRecognizer];

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
    [[[PostRequest alloc] init] exec:@"venue_followers/set" params:[NSString stringWithFormat:@"venue_id=%@&following=%@", appDelegate.activeVenue[@"id"], (following ? @"true" : @"false")] delegate:self callback:@selector(doNothing:) type:@"string"];
}

- (void)doNothing:(id)whoCares {
    [self.view hideToastActivity];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    following = [appDelegate.activeVenue[@"following"] intValue] == 0 ? NO : YES;

    cellImages = [[NSMutableDictionary alloc]init];

    if (!summaryContent) summaryContent = @"";

    [self.checkInButton setTitleTextAttributes:
     @{UITextAttributeTextColor: [UIColor whiteColor],
       UITextAttributeTextShadowColor: [UIColor clearColor],
       UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, 0)],
       UITextAttributeFont: [UIFont systemFontOfSize:14.0]}
                                      forState:UIControlStateNormal];

    textViewOpen = false;
    self.crowdCollectionV.dataSource = self;
    self.crowdCollectionV.delegate = self;

    self.crowdCollectionV.alwaysBounceVertical = YES;

    promotionTitle = @"";
    promotionExpiry = @"";
    promotionBody = @"";

    [self displayTextView];

    [self configureMapWithLat:venueLat longitude:venueLon];

    refreshControl = [[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(startRefresh:)
             forControlEvents:UIControlEventValueChanged];
    [self.crowdCollectionV addSubview:refreshControl];

    [overlayView.scrollView setScrollsToTop:NO];
    [self.crowdCollectionV setScrollsToTop:YES];

    [[[PostRequest alloc]init]exec:@"venue_views/set" params:[NSString stringWithFormat:@"venue_id=%@", appDelegate.activeVenue[@"id"]] delegate:self callback:@selector(doNothing:) type:@"string"];
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

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return appDelegate.posts ? [appDelegate.posts count] : 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    CrowdItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];

    item.index = indexPath.item;
    item.crowdImage.backgroundColor = [UIColor lightGrayColor];
    item.crowdImage.image = [ImageCache get:@"post" identifier:appDelegate.posts[indexPath.item][@"id"]];

    if (item.crowdImage.image == nil) [[[ImageCache alloc]init]get:@"post" identifier:[appDelegate.posts[indexPath.item][@"id"] stringValue] delegate:self callback:@selector(didFinishDownloadingImages:forIndex:) indexPath:indexPath];

    [[item venueName] setText:[self getDateFromUnixFormat:appDelegate.posts[indexPath.item][@"time"]]];
    [[item venueName] setTextColor:[UIColor whiteColor]];
    [[item venueName] setFont:[UIFont systemFontOfSize:11]];

    return item;
}

- (void)didFinishDownloadingImages:(UIImage *)response forIndex:(NSIndexPath *)index {
    if (appDelegate.posts != nil) {
        if (index.item == 0) {
            appDelegate.shareImage = [ImageCache get:@"post" identifier:appDelegate.posts[0][@"id"]];
        }

        if (response != nil) {
            [self.crowdCollectionV reloadItemsAtIndexPaths:@[index]];
        }
    }
}

- (void)displayTextView {
    if (!textViewOpen) {
        overlayView = [[NSBundle mainBundle] loadNibNamed:@"OverlayText" owner:self options:nil][0];
        CGRect screenRect = [[UIScreen mainScreen] bounds];
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
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:lat
                                                            longitude:lon
                                                                 zoom:14];
    overlayView.venueMap.camera = camera;

    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(lat, lon);
    marker.title = @"";
    marker.snippet = @"";
    marker.map = overlayView.venueMap;
    overlayView.venueMap.userInteractionEnabled = NO;
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    return YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;

    if ([appDelegate.activeVenue[@"manager"] intValue] == 1) {
        [self setStatus:Manager];
    } else if ([appDelegate.activeVenue[@"staff"] intValue] == 1) {
        [self setStatus:Staff];
    } else {
        [self setStatus:Default];
    }
}

- (void)setPromoContentTo:(NSString *)promoContent promoHeadline:(NSString *)promoHeadline promoExpiry:(NSString *)promoExpiry {
    overlayView.promotionContents.text = promoContent;
    overlayView.promotionHeadline.text = promoHeadline;
    overlayView.promotionCount.text = promoExpiry;

    overlayView.promotionCount.font = [UIFont systemFontOfSize:9];
    overlayView.promotionCount.textAlignment = NSTextAlignmentCenter;
    overlayView.promotionHeadline.font = [UIFont systemFontOfSize:11];
    overlayView.promotionHeadline.textAlignment = NSTextAlignmentCenter;
    overlayView.promotionContents.font = [UIFont systemFontOfSize:22];
    overlayView.promotionContents.textColor = [UIColor whiteColor];
    overlayView.promotionContents.textAlignment = NSTextAlignmentCenter;
}

- (void)getPosts {
    NSMutableString *params = [[NSMutableString alloc]initWithString:@"venue_id="];
    [params appendString:[appDelegate.activeVenue[@"id"] stringValue]];

    [[[PostRequest alloc]init]exec:@"posts/get" params:params delegate:self callback:@selector(didFinishDownloadingPosts:)];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [overlayView setTabBarHidden:YES animated:NO];
    [self setPromoContentTo:promotionBody promoHeadline:promotionTitle promoExpiry:promotionExpiry];
    overlayView.summaryContentTextField.text = summaryContent;
    overlayView.summaryHeadlineTextField.text = summaryHeadline;
    NSLog(@"Official status: %@ type: %@",appDelegate.activeVenue[@"official"],[appDelegate.activeVenue[@"official"] class]);
    
    overlayView.promotionImage.hidden = YES;
    overlayView.promotionHeadline.hidden = YES;
    overlayView.promotionContents.hidden = YES;
    overlayView.promotionCount.hidden = YES;
    overlayView.claimVenueButton.hidden = YES;
    overlayView.summaryContentTextField.hidden = YES;
    overlayView.summaryHeadlineTextField.hidden = YES;
    
    
    if([appDelegate.activeVenue[@"verified"] intValue] == 1)
    {
        overlayView.promotionImage.hidden = NO;
        overlayView.promotionHeadline.hidden = NO;
        overlayView.promotionContents.hidden = NO;
        overlayView.promotionCount.hidden = NO;
        overlayView.claimVenueButton.hidden = YES;
        overlayView.summaryContentTextField.hidden = NO;
        overlayView.summaryHeadlineTextField.hidden = NO;
    }else if([appDelegate.activeVenue[@"official"] intValue] == 0)
    {
        overlayView.claimVenueButton.hidden = NO;
        
    }else if([appDelegate.activeVenue[@"official"] intValue] == 1)
    {
    }

    
    [self getPosts];
}

- (void)didFinishDownloadingPosts:(id)response {
    appDelegate.posts = response;
    [self.crowdCollectionV reloadData];
    [refreshControl endRefreshing];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [overlayView.scrollView setContentOffset:CGPointZero animated:YES];
    self.navigationController.navigationBarHidden = NO;
    //appDelegate.posts = nil;
}

- (void)goToPromotionView {
    PromotionView *promotionView = [[NSBundle mainBundle] loadNibNamed:@"PromotionView" owner:self options:nil][0];
    [promotionView setpromotionTitle:promotionTitle];
    [promotionView setpromotionBody:promotionBody];
    [promotionView setpromotionExpiry:promotionExpiry];

    [self.navigationController pushViewController:promotionView animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ToGallery"]) {
        [segue.destinationViewController setTitle:titleHeader];
        [(VenueGalleryViewController *)segue.destinationViewController setImage : ((CrowdItem *)sender).crowdImage.image withAuthor :[NSString stringWithFormat:@"%@ %@", appDelegate.posts[selectedPost][@"forename"], [appDelegate.posts[selectedPost][@"surname"] substringToIndex:1]] withComment : appDelegate.posts[selectedPost][@"caption"] withTimestamp :[self getDateFromUnixFormat:appDelegate.posts[selectedPost][@"time"]] withId :[appDelegate.posts[selectedPost][@"id"] stringValue]];
    } else if ([segue.identifier isEqualToString:@"CheckInFromVenue"]) {
        appDelegate.shareVenue = NO;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    selectedPost = indexPath.item;
    appDelegate.shareActivePostId = appDelegate.posts[selectedPost][@"id"];
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
    }
    [overlayView didAppear];
}

- (NSString *)getDateFromUnixFormat:(id)unixFormat {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[unixFormat intValue]];
    return [date timeAgoWithLimit:86400 dateFormat:NSDateFormatterShortStyle andTimeFormat:NSDateFormatterShortStyle];
}

@end

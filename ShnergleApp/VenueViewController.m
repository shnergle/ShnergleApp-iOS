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
#import "PromotionDetailView.h"

@implementation VenueViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }


    return self;
}

- (void)setTitle:(NSString *)title
{
    self.navigationItem.title = title;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self checkInButton] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor], UITextAttributeTextColor,
      [UIColor clearColor], UITextAttributeTextShadowColor,
      [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset,
      [UIFont fontWithName:@"Roboto" size:14.0], UITextAttributeFont,
      nil]
     forState:UIControlStateNormal];

    textViewOpen = false;
    [[self crowdCollectionV]setDataSource:self];
    [[self crowdCollectionV]setDelegate:self];

    images = [[NSArray alloc] initWithObjects:@"liverpool.JPG", @"liverpool2.jpg", @"mahiki.jpg",@"liverpool.JPG", @"liverpool2.jpg", @"mahiki.jpg",@"liverpool.JPG", @"liverpool2.jpg", @"mahiki.jpg",@"liverpool2.jpg", @"mahiki.jpg",@"liverpool2.jpg", @"mahiki.jpg",@"liverpool2.jpg", @"mahiki.jpg",@"liverpool.JPG", @"liverpool2.jpg", @"mahiki.jpg",@"liverpool.JPG", @"liverpool2.jpg", @"mahiki.jpg",@"liverpool.JPG", @"liverpool2.jpg", @"mahiki.jpg",@"liverpool2.jpg", @"mahiki.jpg",@"liverpool2.jpg", @"mahiki.jpg",@"liverpool2.jpg", @"mahiki.jpg",nil];
    venueNames = [[NSArray alloc] initWithObjects:@"liverpool street station",@"liverpool street station",@"mahiki",@"liverpool street station",@"liverpool street station",@"mahiki",@"liverpool street station",@"liverpool street station",@"mahiki",@"liverpool street station",@"mahiki",@"liverpool street station",@"mahiki",@"liverpool street station",@"mahiki",@"liverpool street station",@"liverpool street station",@"mahiki",@"liverpool street station",@"liverpool street station",@"mahiki",@"liverpool street station",@"liverpool street station",@"mahiki",@"liverpool street station",@"mahiki",@"liverpool street station",@"mahiki",@"liverpool street station",@"mahiki", nil];

    promotionTitle = @"Tonights special offer";
    promotionExpiry = @"Expires at 11 pm";
    promotionBody = @"50% OFF real ale";

    [self displayTextView];

}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //return the number of venue images
    return [images count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    CrowdItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    /* Here we can set the elements of the crowdItem (the cell) in the cellview */
    [[item crowdImage]setImage:[UIImage imageNamed:[images objectAtIndex:indexPath.item]]];
    [[item venueName]setText:[venueNames objectAtIndex:indexPath.item]];


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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)displayTextView {
    if(!textViewOpen) {
        _overlayView = [[[NSBundle mainBundle] loadNibNamed:@"OverlayText" owner:self options:nil] objectAtIndex:0];
        //Get screen height:
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenHeight = screenRect.size.height;


        _overlayView.frame = CGRectMake(_overlayView.bounds.origin.x, screenHeight-70, _overlayView.bounds.size.width, _overlayView.bounds.size.height);
        _overlayView.clipsToBounds = NO;
        [self configureMapWithLat:-33.86 longitude:151.20];
        [self.view addSubview:_overlayView];
        textViewOpen = true;
    }
}

-(void)configureMapWithLat:(CLLocationDegrees )lat longitude:(CLLocationDegrees )lon
{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:lat
                                 longitude:lon
                                 zoom:13];
    self.overlayView.venueMap.camera = camera;

    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(lat, lon);
    marker.title = @"Verb Bar";
    marker.snippet = @"Old men and alcohol";
    marker.map = self.overlayView.venueMap;
    self.overlayView.venueMap.userInteractionEnabled = FALSE;



}
// SCROLLHIDE
-(void)hideOverlay
{
    if(hidden)
        return;

    hidden = YES;

    [self.overlayView setTabBarHidden:YES
     animated:YES];

    /*[self.navigationController setNavigationBarHidden:YES
                                             animated:YES];*/
}

-(void)showOverlay
{
    if(!hidden)
        return;

    hidden = NO;

    [self.overlayView setTabBarHidden:NO
     animated:YES];

    /*[self.navigationController setNavigationBarHidden:NO
                                             animated:YES];*/
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
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

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    [self showOverlay];
    return YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    //[super viewWillAppear:animated];
    //self.navigationItem.hidesBackButton = NO;
    /*[self.navigationController setNavigationBarHidden:hidden
                                             animated:YES];*/

    //self.navigationItem.hidesBackButton = NO;
    self.navigationController.navigationBarHidden = NO;

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.overlayView setTabBarHidden:hidden
     animated:NO];
    UIBarButtonItem *menuButton;
    menuButton = [self createLeftBarButton:@"arrow_west" actionSelector:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = menuButton;
}

-(void)viewDidDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}

-(void)goToPromotionView {

    PromotionView *promotionView = [[[NSBundle mainBundle] loadNibNamed:@"PromotionView" owner:self options:nil] objectAtIndex:0];
    [promotionView setpromotionTitle:promotionTitle];
    [promotionView setpromotionBody:promotionBody];
    [promotionView setpromotionExpiry:promotionExpiry];



    [self.view addSubview:promotionView];
}

-(void)goToPromotionDetailView {
    PromotionDetailView *promotionDetailView = [[[NSBundle mainBundle] loadNibNamed:@"PromotionDetailView" owner:self options:nil] objectAtIndex:0];

    [self.view addSubview:promotionDetailView];
}

- (UIBarButtonItem *)createLeftBarButton:(NSString *)imageName actionSelector:(SEL)actionSelector
{
    UIImage *menuButtonImg = [UIImage imageNamed:imageName];

    UIButton *menuButtonTmp = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButtonTmp.frame = CGRectMake(280.0, 10.0, 19.0, 16.0);
    [menuButtonTmp setBackgroundImage:menuButtonImg forState:UIControlStateNormal];
    [menuButtonTmp addTarget:self action:actionSelector forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc]initWithCustomView:menuButtonTmp];
    return menuButton;
}

//workaround to get the custom back button to work
- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
//
//  ViewController.m
//  ShnergleApp
//
//  Created by Stian Johansen on 3/21/13.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "ViewController.h"
#import "CrowdItem.h"
#import <GoogleMaps/GoogleMaps.h>
#import "CoreLocation/CoreLocation.h"
#import "MenuViewController.h"

@interface ViewController ()
{
    NSArray *venueNames;
    NSArray *images;
    NSInteger selectedVenue;
    Boolean crowdImagesHidden;
    Boolean dropDownHidden;
    Boolean hasPositionLocked;
}


@end

@implementation ViewController


// Don't need to modify the default initWithNibName:bundle: method.



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



- (void)decorateCheckInButton
{
    //check in button
    [[self checkInButton] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor], UITextAttributeTextColor,
      [UIColor clearColor], UITextAttributeTextShadowColor,
      [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset,
      [UIFont fontWithName:@"Roboto" size:14.0], UITextAttributeFont,
      nil]
     forState:UIControlStateNormal];
}

- (void)toolbarDecorations
{
    //TOOLBAR Additions
    UIBarButtonItem *menuButton;
    menuButton = [self createLeftBarButton:@"arrow_west.png" actionSelector:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = menuButton;

    //[[self navigationItem] setBackBarButtonItem:menuButton];
}

//workaround to get the custom back button to work
- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIBarButtonItem *)createLeftBarButton:(NSString *)imageName actionSelector:(SEL)actionSelector
{
    UIImage *menuButtonImg = [UIImage imageNamed:imageName];

    UIButton *menuButtonTmp = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButtonTmp.frame = CGRectMake(280.0, 10.0, 22.0, 22.0);
    [menuButtonTmp setBackgroundImage:menuButtonImg forState:UIControlStateNormal];
    [menuButtonTmp addTarget:self action:actionSelector forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc]initWithCustomView:menuButtonTmp];
    return menuButton;
}

- (void)menuButtonDecorations
{
    SEL actionSelector = @selector(tapMenu);
    NSString *imageName = @"mainmenu_button.png";


    UIBarButtonItem *menuButton;
    menuButton = [self createLeftBarButton:imageName actionSelector:actionSelector];


    self.navBarMenuItem.leftBarButtonItem = menuButton;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self decorateCheckInButton];
    [self toolbarDecorations];

    //CROWD stuff
    [[self crowdCollection]setDataSource:self];
    [[self crowdCollection]setDelegate:self];
    //[self createTitleButton];
    images = [[NSArray alloc] initWithObjects:@"liverpool.JPG", @"liverpool2.jpg", @"mahiki.jpg",@"liverpool.JPG", @"liverpool2.jpg", @"mahiki.jpg",@"liverpool.JPG", @"liverpool2.jpg", @"mahiki.jpg",nil];
    venueNames = [[NSArray alloc] initWithObjects:@"liverpool street station",@"liverpool street station",@"mahiki",@"liverpool street station",@"liverpool street station",@"mahiki",@"liverpool street station",@"liverpool street station",@"mahiki", nil];

    crowdImagesHidden = NO;
    dropDownHidden = YES;


    [self menuButtonDecorations];

    [self initMap];




}

-(void)viewDidAppear:(BOOL)animated
{
    [self addShadowToDistanceSlider];

    CALayer *topBorder = [CALayer layer];

    topBorder.frame = CGRectMake(0.0f, self.overlay.bounds.origin.y +35, self.overlay.frame.size.width, 1.0f);

    topBorder.backgroundColor = [UIColor lightGrayColor].CGColor;

    [self.overlay.layer addSublayer:topBorder];

}

- (void)addShadowToDistanceSlider {
    CALayer *bottomBorder = [CALayer layer];

    bottomBorder.frame = CGRectMake(0.0f, 70.0f, self.distanceScrollerView.frame.size.width, 1.0f);

    bottomBorder.backgroundColor = [UIColor lightGrayColor].CGColor;

    [self.distanceScrollerView.layer addSublayer:bottomBorder];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.hidesBackButton = YES;
    //Make it hidden whenever we navigate back to the view as well.
    dropDownHidden = YES;
    crowdImagesHidden = NO;
    //THE SANDWICH MENU SYSTEM (ECSlidingViewController)
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"AroundMeMenu"];
    }

    [self.slidingViewController setAnchorRightRevealAmount:230.0f];

    // Shadow for sandwich system
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;

    //Remove shadows for navbar
    self.navigationController.navigationBar.clipsToBounds = YES;
    self.navBar.clipsToBounds = YES;

    crowdImagesHidden = false;

    [self addShadowToDistanceSlider];


    //self.overlay.layer.shouldRasterize = YES;



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

    [[item crowdImage]setImage:[UIImage imageNamed:[images objectAtIndex:indexPath.item]]];

    [[item venueName]setText:[venueNames objectAtIndex:indexPath.item]];

    item.venueName.font= [UIFont fontWithName:@"Roboto" size:11.0f];

    item.venueName.textColor = [UIColor whiteColor];

    return item;



}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ToVenueSite"]) {
        [segue.destinationViewController setTitle:[venueNames objectAtIndex:selectedVenue]];
    }
}

- (void)collectionView:(UICollectionView *)collectionView
    didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    selectedVenue = indexPath.row;
}

- (void)createTitleButton {
    /*
       //Setup the custom middle buttons
       //------------------------------
       // Euurgh this changes every headline in this navigation!
       //------------------------------
       UIView *container = [[UIView alloc] init];
       container.frame = CGRectMake(0, 0, 80, 44);
       // create a button and add it to the container
       UIButton *notificationButton = [UIButton buttonWithType:UIButtonTypeCustom];
       notificationButton.frame = CGRectMake(0, 0, 35, 44);
       notificationButton.backgroundColor = [UIColor redColor];
       [container addSubview:notificationButton];
       // Set the titleView to the container view
       [self.navigationItem setTitleView:container];
     */
}

- (IBAction)tapMap:(id)sender {
    /*if(crowdImagesHidden){
        [self showOverlay];
       }else{
        [self hideOverlay];
       }
     */
}
/*
   - (IBAction)tapTitle:(id)sender {
    NSLog(@"tapTitle run from ViewController");
    if(dropDownHidden){
    [[self dropDownMenu] showAnimated:0 animationDelay:0 animationDuration:0.5];
        dropDownIndicator.highlighted = YES;
        dropDownHidden = NO;
    }else {
        [[self dropDownMenu] hideAnimated:0 animationDuration:0.5 targetSize:-280 contentView:[self dropDownMenu]];
        dropDownIndicator.highlighted = NO;
        dropDownHidden = YES;
    }
   }
 */

-(void)showOverlay {

    [[self overlay] showAnimated:126 animationDelay:0.2 animationDuration:0.5];

    crowdImagesHidden = NO;
}

-(void)hideOverlay {
    [[self overlay] hideAnimated:126 animationDuration:0.5 targetSize:350 contentView:[self overlay]];
    crowdImagesHidden = YES;
}

-(void)showDistanceScroller {
    [[self distanceScrollerView] showAnimated:44 animationDelay:0.0 animationDuration:0.5];
}

-(void)hideDistanceScroller {
    [[self distanceScrollerView]hideAnimated:44 animationDuration:0.8 targetSize:-64 contentView:[self distanceScrollerView]];
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    NSLog(@"Scrolled to top");
    return YES;
}

-(void)tapMenu
{
    
    NSLog(@"menu triggered from button");
    [self.slidingViewController anchorTopViewTo:ECRight];
    crowdImagesHidden=NO;
    dropDownHidden=YES;

}

-(IBAction)tapMenu:(id)sender
{
    NSLog(@"triggering menu by swipe");
    [self tapMenu];
}


- (void)drawerButtonImage:(NSString *)imagenamed {
    [self.drawerCloseButton setImage:[UIImage imageNamed:imagenamed] forState:UIControlStateNormal];
}

- (IBAction)tapArrow:(id)sender {


    if(crowdImagesHidden) {
        [self showOverlay];
        [self hideDistanceScroller];
        [self drawerButtonImage:@"arrowDown.png"];
    }else{
        [self hideOverlay];
        [self showDistanceScroller];
        [self drawerButtonImage:@"arrowUp.png"];
    }


}

-(void)initMap
{
    hasPositionLocked = FALSE;
    self.mapView.myLocationEnabled = YES;
    [self.mapView addObserver:self forKeyPath:@"myLocation" options:NSKeyValueObservingOptionNew context: nil];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // TODO: CHANGE THE ZOOM
    // How it works:
    // Whenever position changes, this method is run. It then changes the camera to point to the current position, minus a small latitude (to make the map position center in the top part of our Around Me view). The zoom level is an average level of detail for a few blocks.

    //SIDE EFFECT:
    //-- always bounces back to current position. makes better sense to do this once.

    //Make sure it is only run once:
    if(!hasPositionLocked) {
        NSLog(@"the location observer is being run");
        if ([keyPath isEqualToString:@"myLocation"] && [object isKindOfClass:[GMSMapView class]])
        {
            [self.mapView animateToCameraPosition:[GMSCameraPosition cameraWithLatitude:self.mapView.myLocation.coordinate.latitude -0.012
                                                   longitude:self.mapView.myLocation.coordinate.longitude
                                                   zoom:13]];
            hasPositionLocked = TRUE;
        }

    }

}

// MAP FUNCTIONS -- DOES NOT WORK.
- (void)mapView:(GMSMapView *)mapView
    didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {

    NSLog(@"tapped at coords %f, %f",coordinate.latitude,coordinate.longitude);
    GMSMarker *marker = [GMSMarker markerWithPosition:coordinate];
    marker.title = @"Hello World";
    marker.map = self.mapView;

}


@end

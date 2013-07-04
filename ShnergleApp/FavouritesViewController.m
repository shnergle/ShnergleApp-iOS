//
//  FavouritesViewController.m
//  ShnergleApp
//
//  Created by Stian Johansen on 06/06/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "FavouritesViewController.h"
#import "MenuViewController.h"
#import "AppDelegate.h"
#import "CrowdItem.h"
#import "AppDelegate.h"
#import "VenueViewController.h"
#import "PostRequest.h"
#import "ImageCache.h"

@implementation FavouritesViewController {
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


    self.navBarItem.leftBarButtonItem = menuButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if (appDelegate.topViewType) ((UINavigationItem *)self.navBar.items[0]).title = appDelegate.topViewType;
    [self menuButtonDecorations];
    [self decorateCheckInButton];
    [[self crowdCollection] setDataSource:self];
    [[self crowdCollection] setDelegate:self];

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

    //remove shadow from navbar
    self.navigationController.navigationBar.clipsToBounds = YES;
    self.navBar.clipsToBounds = YES;

    [self makeRequest];
}

- (void)makeRequest {
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    [[[PostRequest alloc] init]exec:@"venue_favourites/get" params:[NSString stringWithFormat:@"facebook_id=%@", appDelegate.facebookId] delegate:self callback:@selector(didFinishLoadingVenues:)];
}

- (void)didFinishLoadingVenues:(NSArray *)response {
    NSLog(@"%@",response);
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    appDelegate.aroundVenues = response;
    [self.crowdCollection reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tapMenu {
    [self.slidingViewController anchorTopViewTo:ECRight];
}

//Copy from aroundMe
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    return [appDelegate.topViewType isEqual:@"Following"] ? [appDelegate.followingVenues count] : [appDelegate.images count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"FavCell";
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
    [[[ImageCache alloc]init]get:@"venue" identifier:[appDelegate.aroundVenues[indexPath.item][@"id"] stringValue] delegate:self callback:@selector(didFinishDownloadingImages:forItem:) item:item];

    [[item venueName] setText:([appDelegate.topViewType isEqual:@"Following"] ? appDelegate.followingVenues : appDelegate.venueNames)[indexPath.item][@"name"]];

    item.venueName.font = [UIFont systemFontOfSize:11.0f];

    item.venueName.textColor = [UIColor whiteColor];

    //Turn the indicator on or off:
    if ([item.venueName.text isEqual:@"mahiki"]) { //just an example filter
        item.promotionIndicator.hidden = YES;
    } else {
        item.promotionIndicator.hidden = NO;
    }

    return item;
}

- (void)didFinishDownloadingImages:(UIImage *)response forItem:(CrowdItem *)item {
    [[item crowdImage] setImage:response];
}

- (void)         collectionView:(UICollectionView *)collectionView
    didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.activeVenue = appDelegate.followingVenues[indexPath.row];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if ([segue.identifier isEqualToString:@"ToVenueSite"]) {
        [(VenueViewController *)segue.destinationViewController setVenue : appDelegate.activeVenue];
    }
}

@end

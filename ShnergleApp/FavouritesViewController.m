//
//  FavouritesViewController.m
//  ShnergleApp
//
//  Created by Stian Johansen on 06/06/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "FavouritesViewController.h"
#import "MenuViewController.h"
#import "CrowdItem.h"
#import "VenueViewController.h"
#import "PostRequest.h"
#import "ImageCache.h"
#import <ECSlidingViewController/ECSlidingViewController.h>
#import <Toast/Toast+UIView.h>

@implementation FavouritesViewController

- (void)decorateCheckInButton {
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

    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:menuButtonTmp];
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
    appDelegate.followingVenues = @[];
    appDelegate.quietVenues = @[];
    appDelegate.trendingVenues = @[];
    if (appDelegate.topViewType) ((UINavigationItem *)self.navBar.items[0]).title = appDelegate.topViewType;
    [self menuButtonDecorations];
    [self decorateCheckInButton];
    [[self crowdCollection] setDataSource:self];
    [[self crowdCollection] setDelegate:self];

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
}

#warning replace placeholder values with real values (lat/lon of user, distance in degress, from time (current timestamp - 86400) and until time (current timestamp))
- (void)makeRequest {
    [self.view makeToastActivity];
    if ([@"Following" isEqualToString:appDelegate.topViewType]) {
        [[[PostRequest alloc] init] exec:@"venues/get" params:@"following_only=true" delegate:self callback:@selector(didFinishLoadingVenues:)];
    } else if ([@"Quiet" isEqualToString:appDelegate.topViewType]) {
        [[[PostRequest alloc] init] exec:@"venues/get" params:@"quiet=true&my_lat=0&my_lon=0&distance=100&from_time=0&until_time=999999999999" delegate:self callback:@selector(didFinishLoadingVenues:)];
    } else if ([@"Trending" isEqualToString:appDelegate.topViewType]) {
        [[[PostRequest alloc] init] exec:@"venues/get" params:@"trending=true&my_lat=0&my_lon=0&distance=100&from_time=0&until_time=999999999999" delegate:self callback:@selector(didFinishLoadingVenues:)];
    }
}

- (void)didFinishLoadingVenues:(NSArray *)response {
    if ([@"Following" isEqualToString:appDelegate.topViewType]) {
        appDelegate.followingVenues = response;
    } else if ([@"Quiet" isEqualToString:appDelegate.topViewType]) {
        appDelegate.quietVenues = response;
    } else if ([@"Trending" isEqualToString:appDelegate.topViewType]) {
        appDelegate.trendingVenues = response;
    }
    [self.crowdCollection reloadData];
    [self.view hideToastActivity];
}

- (void)tapMenu {
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([@"Following" isEqualToString:appDelegate.topViewType]) {
        return [appDelegate.followingVenues count];
    } else if ([@"Quiet" isEqualToString:appDelegate.topViewType]) {
        return [appDelegate.quietVenues count];
    } else if ([@"Trending" isEqualToString:appDelegate.topViewType]) {
        return [appDelegate.trendingVenues count];
    } else {
        return 0;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self makeRequest];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"FavCell";
    CrowdItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];

    NSArray *type;
    if ([@"Following" isEqualToString:appDelegate.topViewType]) {
        type = appDelegate.followingVenues;
    } else if ([@"Quiet" isEqualToString:appDelegate.topViewType]) {
        type = appDelegate.quietVenues;
    } else if ([@"Trending" isEqualToString:appDelegate.topViewType]) {
        type = appDelegate.trendingVenues;
    }

    item.crowdImage.image = [ImageCache get:@"venue" identifier:type[indexPath.item][@"id"]];
    item.crowdImage.backgroundColor = [UIColor lightGrayColor];
    if (item.crowdImage.image == nil) [[[ImageCache alloc] init] get:@"venue" identifier:[type[indexPath.item][@"id"] stringValue] delegate:self callback:@selector(didFinishDownloadingImages:forIndex:) indexPath:indexPath];

    [[item venueName] setText:type[indexPath.item][@"name"]];

    item.venueName.font = [UIFont systemFontOfSize:11.0f];

    item.venueName.textColor = [UIColor whiteColor];

    if (type[indexPath.item][@"promotion"] != nil) {
        item.promotionIndicator.hidden = NO;
    } else {
        item.promotionIndicator.hidden = YES;
    }

    return item;
}

- (void)didFinishDownloadingImages:(UIImage *)response forIndex:(NSIndexPath *)index {
    if (response != nil) {
        [self.crowdCollection reloadItemsAtIndexPaths:@[index]];
    }
}

- (void)collectionView:(UICollectionView *)collectionView
    didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *type;
    if ([@"Following" isEqualToString:appDelegate.topViewType]) {
        type = appDelegate.followingVenues;
    } else if ([@"Quiet" isEqualToString:appDelegate.topViewType]) {
        type = appDelegate.quietVenues;
    } else if ([@"Trending" isEqualToString:appDelegate.topViewType]) {
        type = appDelegate.trendingVenues;
    }
    appDelegate.activeVenue = type[indexPath.row];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"CheckInFromFollowing"]) {
        appDelegate.shareVenue = NO;
    }
}

@end

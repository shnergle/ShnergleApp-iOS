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
#import <NSDate-Escort/NSDate+Escort.h>

@implementation FavouritesViewController

- (void)decorateCheckInButton {
    [self.checkInButton setTitleTextAttributes:
     @{UITextAttributeTextColor: [[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending ? [UIColor colorWithRed:51.0 / 250 green:140.0 / 250 blue:16.0 / 250 alpha:1.0] : [UIColor whiteColor],
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
    UIBarButtonItem *menuButton;
    if (self.slidingViewController != nil) menuButton = [self createLeftBarButton:@"mainmenu_button.png" actionSelector:@selector(tapMenu)];
    else menuButton = [self createLeftBarButton:@"arrow_west.png" actionSelector:@selector(goBack)];

    self.navBarItem.leftBarButtonItem = menuButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    venues = @[];
    if (!appDelegate.topViewType) appDelegate.topViewType = @"Following";
    ((UINavigationItem *)self.navBar.items[0]).title = appDelegate.topViewType;
    [self menuButtonDecorations];
    [self decorateCheckInButton];

    if (self.slidingViewController != nil) {
        if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
            self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"AroundMeMenu"];
        }
        [self.view addGestureRecognizer:self.slidingViewController.panGesture];
        [self.slidingViewController setAnchorRightRevealAmount:230.0f];
    }

    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;

    self.navigationController.navigationBar.clipsToBounds = YES;
    self.navBar.clipsToBounds = YES;

    if ([self.navBar respondsToSelector:@selector(setBarTintColor:)]) [self.navBar performSelector:@selector(setBarTintColor:) withObject:[UIColor colorWithRed:233.0 / 255 green:235.0 / 255 blue:240.0 / 255 alpha:1.0]];
    self.navBar.translucent = NO;
}

- (void)makeRequest {
    [self.view makeToastActivity];
    if ([@"Following" isEqualToString : appDelegate.topViewType]) {
        [[[PostRequest alloc] init] exec:@"venues/get" params:@{@"following_only" : @"true", @"level" : appDelegate.level} delegate:self callback:@selector(didFinishLoadingVenues:)];
    } else {
        hasPositionLocked = NO;
        man = [[CLLocationManager alloc] init];
        man.delegate = self;
        man.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        [man startUpdatingLocation];
    }
}

- (int)fromTime {
    NSDate *date;
    if ([[NSDate dateWithHoursBeforeNow:6] isYesterday]) {
        date = [[[NSDate dateYesterday] dateAtStartOfDay] dateByAddingHours:6];
    } else {
        date = [[[NSDate date] dateAtStartOfDay] dateByAddingHours:6];
    }
    return (int)[date timeIntervalSince1970];
}

- (int)untilTime {
    NSDate *date;
    if ([[NSDate dateWithHoursBeforeNow:6] isYesterday]) {
        date = [[[NSDate date] dateAtStartOfDay] dateByAddingHours:6];
    } else {
        date = [[[NSDate dateTomorrow] dateAtStartOfDay] dateByAddingHours:6];
    }
    return (int)[date timeIntervalSince1970];
}

- (void)didFinishLoadingVenues:(NSArray *)response {
    venues = response;
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
    return [venues count];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self makeRequest];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"FavCell";
    CrowdItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];

    item.crowdImage.image = [ImageCache get:@"venue" identifier:venues[indexPath.item][@"id"]];
    item.crowdImage.backgroundColor = [UIColor lightGrayColor];
    if (item.crowdImage.image == nil) [[[ImageCache alloc] init] get:@"venue" identifier:[venues[indexPath.item][@"id"] stringValue] delegate:self callback:@selector(didFinishDownloadingImages:forIndex:) indexPath:indexPath];

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

- (void)collectionView:(UICollectionView *)collectionView
    didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    appDelegate.activeVenue = venues[indexPath.row];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"CheckInFromFollowing"]) {
        appDelegate.shareVenue = NO;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    if (!hasPositionLocked) {
        NSMutableDictionary *params = [@{@"my_lat": @(((CLLocation *)locations.lastObject).coordinate.latitude),
                                         @"my_lon": @(((CLLocation *)locations.lastObject).coordinate.longitude),
                                         @"distance": @0.1,
                                         @"level": appDelegate.level} mutableCopy];
        if ([@"Quiet" isEqualToString : appDelegate.topViewType]) {
            [params addEntriesFromDictionary:@{@"quiet" : @"true",
                                               @"from_time" : @([self fromTime]),
                                               @"until_time" : @([self untilTime])}];
            [[[PostRequest alloc] init] exec:@"venues/get" params:params delegate:self callback:@selector(didFinishLoadingVenues:)];
        } else if ([@"Trending" isEqualToString : appDelegate.topViewType]) {
            [params addEntriesFromDictionary:@{@"trending" : @"true",
                                               @"from_time" : @([self fromTime]),
                                               @"until_time" : @([self untilTime])}];
            [[[PostRequest alloc] init] exec:@"venues/get" params:params delegate:self callback:@selector(didFinishLoadingVenues:)];
        } else if ([@"Promotions" isEqualToString : appDelegate.topViewType]) {
            [params addEntriesFromDictionary:@{@"promotions" : @"true",
                                               @"from_time" : @([self fromTime]),
                                               @"until_time" : @([self untilTime])}];
            [[[PostRequest alloc] init] exec:@"venues/get" params:params delegate:self callback:@selector(didFinishLoadingVenues:)];
        }
        hasPositionLocked = YES;
    }
}

@end

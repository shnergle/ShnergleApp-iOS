//
//  FavouritesViewController.m
//  ShnergleApp
//
//  Created by Stian Johansen on 06/06/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "FavouritesViewController.h"
#import "CrowdItem.h"
#import "Request.h"
#import <ECSlidingViewController/ECSlidingViewController.h>
#import <Toast/Toast+UIView.h>
#import <MapKit/MapKit.h>

@implementation FavouritesViewController

- (void)decorateCheckInButton {
    [self.checkInButton setTitleTextAttributes:
     @{NSForegroundColorAttributeName: [UIColor colorWithRed:51.0 / 250 green:140.0 / 250 blue:16.0 / 250 alpha:1.0],
       NSFontAttributeName: [UIFont systemFontOfSize:14.0]}
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
    if (self.slidingViewController != nil) menuButton = [self createLeftBarButton:@"mainmenu_button" actionSelector:@selector(tapMenu)];
    else menuButton = [self createLeftBarButton:@"arrow_west" actionSelector:@selector(goBack)];

    self.navBarItem.leftBarButtonItem = menuButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    venues = @[];
    if (!appDelegate.topViewType) appDelegate.topViewType = @"Following";
    ((UINavigationItem *)self.navBar.items[0]).title = appDelegate.topViewType;
    [self menuButtonDecorations];
    [self decorateCheckInButton];

    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;

    self.navigationController.navigationBar.clipsToBounds = YES;
    self.navBar.clipsToBounds = YES;

    self.navBar.barTintColor = [UIColor colorWithRed:233.0 / 255 green:235.0 / 255 blue:240.0 / 255 alpha:1.0];
    self.navBar.translucent = NO;
}

- (void)didFinishLoadingVenues:(NSArray *)response {
    @synchronized(self) {
        venues = response;
        [self.crowdCollection reloadData];
        [self.view hideToastActivity];
    }
}

- (void)tapMenu {
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [venues count];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view makeToastActivity];
     if ([@"Following" isEqualToString : appDelegate.topViewType]) {
         [Request post:@"venues/get" params:@{@"following_only" : @"true", @"level" : appDelegate.level} callback:^(id response) {
             [self didFinishLoadingVenues:response];
         }];
     } else {
         hasPositionLocked = NO;
         man = [[CLLocationManager alloc] init];
         man.delegate = self;
         man.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
         [man startUpdatingLocation];
     }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"FavCell";
    CrowdItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];

    NSDictionary *key = @{@"entity": @"venue",
                          @"entity_id": venues[indexPath.item][@"id"]};
    item.crowdImage.backgroundColor = [UIColor lightGrayColor];
    if (!(item.crowdImage.image = [Request getImage:key])) {
        [Request post:@"images/get" params:key callback:^(id response) {
            if (response != nil && self.crowdCollection != nil && [self.crowdCollection numberOfItemsInSection:indexPath.section] > indexPath.item) {
                [self.crowdCollection reloadItemsAtIndexPaths:@[indexPath]];
            }
        }];
    }

    item.venueName.text = venues[indexPath.item][@"name"];
    item.venueName.font = [UIFont systemFontOfSize:11.0f];
    item.venueName.textColor = [UIColor whiteColor];

    if ([venues[indexPath.item][@"promotions"] integerValue] > 0) {
        item.promotionIndicator.hidden = NO;
    } else {
        item.promotionIndicator.hidden = YES;
    }

    if ([venues[indexPath.item][@"following"] integerValue] > 0) {
        item.followingIndicator.hidden = NO;
    } else {
        item.followingIndicator.hidden = YES;
    }

    return item;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    appDelegate.activeVenue = venues[indexPath.item];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    appDelegate.activeVenue = venues[indexPath.item];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"CheckInFromFollowing"]) {
        appDelegate.shareVenue = NO;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    if (!hasPositionLocked) {
        hasPositionLocked = YES;
        MKCoordinateRegion rgn = MKCoordinateRegionMakeWithDistance(((CLLocation *)locations.lastObject).coordinate, 5000, 5000);
        double distanceInDegrees = sqrt(pow(rgn.span.latitudeDelta, 2) + pow(rgn.span.longitudeDelta, 2));
        NSDictionary *params = @{@"my_lat": @(((CLLocation *)locations.lastObject).coordinate.latitude),
                                 @"my_lon": @(((CLLocation *)locations.lastObject).coordinate.longitude),
                                 @"distance": @(distanceInDegrees),
                                 @"level": appDelegate.level,
                                 [appDelegate.topViewType lowercaseString] : @"true",
                                 @"from_time" : @([Request time:NO]),
                                 @"until_time" : @([Request time:YES])};
        [Request post:@"venues/get" params:params callback:^(id response) {
            [self didFinishLoadingVenues:response];
        }];
    }
}

@end

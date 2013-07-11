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

@implementation FavouritesViewController {
}

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
    appDelegate.followingVenues = @[];
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

- (void)makeRequest {
    [[[PostRequest alloc] init]exec:@"venues/get" params:@"following_only=true" delegate:self callback:@selector(didFinishLoadingVenues:)];
}

- (void)didFinishLoadingVenues:(NSArray *)response {
    appDelegate.followingVenues = response;
    [self.crowdCollection reloadData];
}

- (void)tapMenu {
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [appDelegate.topViewType isEqual:@"Following"] ? [appDelegate.followingVenues count] : [appDelegate.images count];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self makeRequest];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"FavCell";
    CrowdItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];

    item.crowdImage.image = [ImageCache get:@"venue" identifier:appDelegate.followingVenues[indexPath.item][@"id"]];
    item.crowdImage.backgroundColor = [UIColor lightGrayColor];
    if (item.crowdImage.image == nil) [[[ImageCache alloc]init]get:@"venue" identifier:[appDelegate.followingVenues[indexPath.item][@"id"] stringValue] delegate:self callback:@selector(didFinishDownloadingImages:forIndex:) indexPath:indexPath];

    [[item venueName] setText:([appDelegate.topViewType isEqual:@"Following"] ? appDelegate.followingVenues : appDelegate.venueNames)[indexPath.item][@"name"]];

    item.venueName.font = [UIFont systemFontOfSize:11.0f];

    item.venueName.textColor = [UIColor whiteColor];

    if (appDelegate.followingVenues[indexPath.item][@"promotion"] != nil) {
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

- (void)         collectionView:(UICollectionView *)collectionView
    didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    appDelegate.activeVenue = appDelegate.followingVenues[indexPath.row];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ToVenueSite"]) {
        [(VenueViewController *)segue.destinationViewController setVenue : appDelegate.activeVenue];
    }
}

@end

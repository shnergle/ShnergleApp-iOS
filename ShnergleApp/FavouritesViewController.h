//
//  FavouritesViewController.h
//  ShnergleApp
//
//  Created by Stian Johansen on 06/06/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "CustomBackViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface FavouritesViewController : CustomBackViewController <UICollectionViewDataSource, UICollectionViewDelegate, CLLocationManagerDelegate> {
    CLLocationManager *man;
    BOOL hasPositionLocked;
    NSArray *venues;
}

@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *navBarItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *checkInButton;
@property (weak, nonatomic) IBOutlet UICollectionView *crowdCollection;

@end

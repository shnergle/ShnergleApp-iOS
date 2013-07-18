//
//  FavouritesViewController.h
//  ShnergleApp
//
//  Created by Stian Johansen on 06/06/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

@interface FavouritesViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, CLLocationManagerDelegate> {
    CLLocationManager *man;
}

@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *navBarItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *checkInButton;
@property (weak, nonatomic) IBOutlet UICollectionView *crowdCollection;

@end

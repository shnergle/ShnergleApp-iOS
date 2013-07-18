//
//  CheckInListViewController.h
//  ShnergleApp
//
//  Created by Adam Hani Schakaki on 18/07/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "CustomBackViewController.h"

@interface CheckInListViewController : CustomBackViewController <UICollectionViewDelegate, UICollectionViewDataSource> {
    NSArray *posts;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

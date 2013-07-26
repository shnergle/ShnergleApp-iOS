//
//  RedemptionListViewController.h
//  ShnergleApp
//
//  Created by Adam Hani Schakaki on 24/07/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "CustomBackViewController.h"

@interface RedemptionListViewController : CustomBackViewController <UICollectionViewDataSource, UICollectionViewDelegate> {
    NSArray *promos;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

//
//  StaffViewController.h
//  ShnergleApp
//
//  Created by Adam Hani Schakaki on 12/06/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "CustomBackViewController.h"

@interface StaffViewController : CustomBackViewController <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

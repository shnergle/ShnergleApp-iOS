//
//  ImpViewController.m
//  ShnergleApp
//
//  Created by Harshita Balaga on 14/08/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "ImpViewController.h"

@implementation ImpViewController

- (IBAction)showInfo:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"We use this figure to calculate the estimated financial value of the Shnergle users checking-in to your venue so that you don’t have to. This information will be kept confidential and will not be shared with anyone." message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.navigationItem.title = @"Important Stuff";
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

@end

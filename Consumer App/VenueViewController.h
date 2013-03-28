//
//  VenueViewController.h
//  Consumer App
//
//  Created by Stian Johansen on 3/22/13.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface VenueViewController : ViewController
@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;
-(void)setTitle:(NSString *)title;

@property (weak, nonatomic) IBOutlet UICollectionView *crowdCollectionV;
- (IBAction)displayTextView:(id)sender;

@end

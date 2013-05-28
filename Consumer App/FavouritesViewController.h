//
//  FavouritesViewController.h
//  Consumer App
//
//  Created by Stian Johansen on 05/05/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "ViewController.h"
#import "overlayText.h"
#import "DropDownMenu.h"
#import <QuartzCore/QuartzCore.h>


@interface FavouritesViewController : UIViewController

- (IBAction)tapTitle:(id)sender;
@property (weak, nonatomic) IBOutlet DropDownMenu *dropDownMenu;

@property (weak, nonatomic) IBOutlet UICollectionView *crowdCollection;

@property (weak, nonatomic) IBOutlet overlayText *overlay;


@end
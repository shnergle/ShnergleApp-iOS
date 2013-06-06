//
//  FavouritesViewController.m
//  ShnergleApp
//
//  Created by Stian Johansen on 05/05/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "FavouritesViewController.h"
#import "CrowdItem.h"

@implementation FavouritesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    dropDownHidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationItem.hidesBackButton = NO;
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapTitle:(id)sender {
    NSLog(@"tapTitle run from FavouritesViewController");
    if (dropDownHidden) {
        [[self dropDownMenu] showAnimated:0 animationDelay:0 animationDuration:0.5];
        dropDownHidden = NO;
    } else {
        [[self dropDownMenu] hideAnimated:0 animationDuration:0.5 targetSize:-280 contentView:[self dropDownMenu]];
        dropDownHidden = YES;
    }
}

@end

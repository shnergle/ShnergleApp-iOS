//
//  FavouritesViewController.m
//  ShnergleApp
//
//  Created by Stian Johansen on 05/05/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "FavouritesSlidingViewController.h"
#import "CrowdItem.h"
#import "FavouritesViewController.h"

@implementation FavouritesSlidingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    FavouritesViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"Favourites"];
    controller.type = _type;
    self.topViewController = controller;
    self.navigationItem.hidesBackButton = YES;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.hidesBackButton = YES;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

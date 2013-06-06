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
    
    UIBarButtonItem *menuButton;
    menuButton = [self createLeftBarButton:@"arrow_west" actionSelector:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = menuButton;
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

- (UIBarButtonItem *)createLeftBarButton:(NSString *)imageName actionSelector:(SEL)actionSelector {
    UIImage *menuButtonImg = [UIImage imageNamed:imageName];

    UIButton *menuButtonTmp = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButtonTmp.frame = CGRectMake(280.0, 10.0, 19.0, 16.0);
    [menuButtonTmp setBackgroundImage:menuButtonImg forState:UIControlStateNormal];
    [menuButtonTmp addTarget:self action:actionSelector forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:menuButtonTmp];
    return menuButton;
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

@end

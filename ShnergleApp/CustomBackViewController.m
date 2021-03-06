//
//  CustomBackViewController.m
//  ShnergleApp
//
//  Created by Adam Hani Schakaki on 06/06/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "CustomBackViewController.h"
#import <FlurrySDK/Flurry.h>

@implementation CustomBackViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = [self createLeftBarButton:@"arrow_west" actionSelector:@selector(goBack)];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.navigationBarHidden = NO;
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

- (void)setRightBarButton:(NSString *)title actionSelector:(SEL)actionSelector {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.rightBarButtonItem.title = title;
    self.navigationItem.rightBarButtonItem.target = self;
    self.navigationItem.rightBarButtonItem.action = actionSelector;
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:
     @{NSForegroundColorAttributeName: [UIColor blackColor],
       NSFontAttributeName: [UIFont systemFontOfSize:14.0]} forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:233.0 / 255 green:235.0 / 255 blue:240.0 / 255 alpha:1.0];
    self.navigationController.navigationBar.translucent = NO;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.edgesForExtendedLayout = UIRectEdgeAll;
    UIView *bar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    bar.backgroundColor = [UIColor colorWithRed:233/255. green:235/255. blue:240/255. alpha:1];
    [self.view addSubview:bar];
    [self.view bringSubviewToFront:bar];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [Flurry logPageView];
    [Flurry logEvent:[NSString stringWithFormat:@"Viewed %@", NSStringFromClass([self class])]];
}

@end

//
//  CustomBackViewController.m
//  ShnergleApp
//
//  Created by Adam Hani Schakaki on 06/06/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "CustomBackViewController.h"

@implementation CustomBackViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIBarButtonItem *menuButton;
    menuButton = [self createLeftBarButton:@"arrow_west" actionSelector:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = menuButton;
    UISwipeGestureRecognizer *swipeBack = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    [self.view addGestureRecognizer:swipeBack];
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
     @{UITextAttributeTextColor: [UIColor blackColor],
       UITextAttributeTextShadowColor: [UIColor clearColor],
       UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, 0)],
       UITextAttributeFont: [UIFont systemFontOfSize:14.0]}
                                                          forState:UIControlStateNormal];
}

@end

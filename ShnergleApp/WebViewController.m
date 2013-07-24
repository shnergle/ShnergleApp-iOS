//
//  WebViewController.m
//  ShnergleApp
//
//  Created by Adam Hani Schakaki on 20/07/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "WebViewController.h"
#import <Toast/Toast+UIView.h>

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.shnergle.com/"]]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.title = @"Privacy Policy";
    [self.view makeToastActivity];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.view hideToastActivity];
}

@end

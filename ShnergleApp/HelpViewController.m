//
//  HelpViewController.m
//  ShnergleApp
//
//  Created by Harshita Balaga on 12/08/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "HelpViewController.h"

@implementation HelpViewController

- (IBAction)fb:(id)sender {
    NSURL *url = [NSURL URLWithString:@"fb://profile/265947480190327"];
    if (![[UIApplication sharedApplication] canOpenURL:url]) {
        url = [NSURL URLWithString:@"https://www.facebook.com/shnergle"];
    }
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)twitter:(id)sender {
    NSURL *url = [NSURL URLWithString:@"twitter://user?screen_name=ShnergleHelp"];
    if (![[UIApplication sharedApplication] canOpenURL:url]) {
        url = [NSURL URLWithString:@"https://www.twitter.com/ShnergleHelp"];
    }
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)mail:(id)sender {
    NSURL *url = [NSURL URLWithString:@"mailto:contact@shnergle.com"];
    [[UIApplication sharedApplication] openURL:url];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.title = @"Help";
}

@end

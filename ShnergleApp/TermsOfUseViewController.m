//
//  TermsOfUseViewController.m
//  ShnergleApp
//
//  Created by Harshita Balaga on 31/07/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "TermsOfUseViewController.h"

@interface TermsOfUseViewController ()

@end

@implementation TermsOfUseViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.title = @"Terms Of Use";
}

@end

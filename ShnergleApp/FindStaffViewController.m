//
//  FindStaffViewController.m
//  ShnergleApp
//
//  Created by Adam Hani Schakaki on 22/07/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "FindStaffViewController.h"
#import <Toast/Toast+UIView.h>
#import "PostRequest.h"

@implementation FindStaffViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.title = @"Add Staff";
    [self.view makeToastActivity];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:@"ASRCell"];
}

@end

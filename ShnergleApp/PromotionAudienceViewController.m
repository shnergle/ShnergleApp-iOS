//
//  PromotionAudienceViewController.m
//  ShnergleApp
//
//  Created by Adam Hani Schakaki on 25/07/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "PromotionAudienceViewController.h"

@implementation PromotionAudienceViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = @[@"Shnerglers", @"Scouts", @"Explorers", @"Everyone"][indexPath.row];
    return cell;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.title = @"Audience";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    appDelegate.audience = 3 - indexPath.row;
    [self goBack];
}

@end

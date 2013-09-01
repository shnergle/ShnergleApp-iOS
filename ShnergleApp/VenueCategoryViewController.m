//
//  VenueCategoryViewController.m
//  ShnergleApp
//
//  Created by Stian Johansen on 10/06/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "VenueCategoryViewController.h"

@implementation VenueCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"+ Add Place";
    categories = @[@{@"id": @18, @"type": @"Airport"},
                   @{@"id": @6, @"type": @"Arts & Entertainment"},
                   @{@"id": @1, @"type": @"Bar"},
                   @{@"id": @19, @"type": @"Bus"},
                   @{@"id": @4, @"type": @"Café"},
                   @{@"id": @8, @"type": @"Club / Society"},
                   @{@"id": @7, @"type": @"College & University"},
                   @{@"id": @23, @"type": @"Cultural / Landmark"},
                   @{@"id": @9, @"type": @"Food"},
                   @{@"id": @10, @"type": @"Great Outdoors"},
                   @{@"id": @5, @"type": @"Gym"},
                   @{@"id": @12, @"type": @"Night Club"},
                   @{@"id": @11, @"type": @"Nightlife"},
                   @{@"id": @17, @"type": @"Professional & Other"},
                   @{@"id": @13, @"type": @"Pub"},
                   @{@"id": @21, @"type": @"Rail"},
                   @{@"id": @14, @"type": @"Residence"},
                   @{@"id": @20, @"type": @"Road"},
                   @{@"id": @15, @"type": @"Shop & Service"},
                   @{@"id": @16, @"type": @"Sports"},
                   @{@"id": @24, @"type": @"Tourist Attraction"},
                   @{@"id": @3, @"type": @"Travel & Transport"},
                   @{@"id": @22, @"type": @"Underground"}];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [categories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.imageView.image = [UIImage imageNamed:[categories[indexPath.row][@"id"] stringValue]];
    UILabel *textView = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 270, cell.bounds.size.height)];
    textView.text = categories[indexPath.row][@"type"];
    textView.font = [UIFont fontWithName:cell.textLabel.font.fontName size:20];
    textView.backgroundColor = tableView.backgroundColor;
    [cell addSubview:textView];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    appDelegate.addVenueType = categories[indexPath.row][@"type"];
    appDelegate.addVenueTypeId = [categories[indexPath.row][@"id"] stringValue];
    [self goBack];
}

@end

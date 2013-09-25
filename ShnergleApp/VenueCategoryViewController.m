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
    categories = @[@{@"id": @18, @"type": @"Airport", @"image": @"glyphicons_038_airplane"},
                   @{@"id": @6, @"type": @"Arts & Entertainment", @"image": @"glyphicons_049_star"},
                   @{@"id": @1, @"type": @"Bar", @"image": @"glyphicons_291_celebration"},
                   @{@"id": @19, @"type": @"Bus", @"image": @"glyphicons_031_bus"},
                   @{@"id": @4, @"type": @"Café", @"image": @"glyphicons_294_coffe_cup"},
                   @{@"id": @8, @"type": @"Club / Society", @"image": @"glyphicons_074_cup"},
                   @{@"id": @7, @"type": @"College & University", @"image": @"glyphicons_263_bank"},
                   @{@"id": @23, @"type": @"Cultural / Landmark", @"image": @"glyphicons_420_tower"},
                   @{@"id": @9, @"type": @"Food", @"image": @"glyphicons_276_cutlery"},
                   @{@"id": @10, @"type": @"Great Outdoors", @"image": @"glyphicons_316_tree_conifer"},
                   @{@"id": @5, @"type": @"Gym", @"image": @"glyphicons_356_dumbbell"},
                   @{@"id": @12, @"type": @"Night Club", @"image": @"glyphicons_371_global"},
                   @{@"id": @11, @"type": @"Nightlife", @"image": @"glyphicons_000_glass"},
                   @{@"id": @17, @"type": @"Professional & Other", @"image": @"glyphicons_341_briefcase"},
                   @{@"id": @13, @"type": @"Pub", @"image": @"glyphicons_274_beer"},
                   @{@"id": @21, @"type": @"Rail", @"image": @"glyphicons_014_train"},
                   @{@"id": @14, @"type": @"Residence", @"image": @"glyphicons_020_home"},
                   @{@"id": @20, @"type": @"Road", @"image": @"glyphicons_026_road"},
                   @{@"id": @15, @"type": @"Shop & Service", @"image": @"glyphicons_350_shopping_bag"},
                   @{@"id": @16, @"type": @"Sports", @"image": @"glyphicons_329_soccer_ball"},
                   @{@"id": @24, @"type": @"Tourist Attraction", @"image": @"glyphicons_011_camera"},
                   @{@"id": @3, @"type": @"Travel & Transport", @"image": @"glyphicons_370_globe_af"},
                   @{@"id": @22, @"type": @"Underground", @"image": @"glyphicons_014_train"}];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [categories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.imageView.image = [UIImage imageNamed:categories[indexPath.row][@"image"]];
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
    [self.navigationController popViewControllerAnimated:YES];
}

@end

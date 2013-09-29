//
//  AddVenueViewController.m
//  ShnergleApp
//
//  Created by Stian Johansen on 10/06/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "AddVenueViewController.h"
#import "Request.h"
#import <Toast+UIView.h>
#import <QuartzCore/QuartzCore.h>

typedef enum {
    Name,
    Category,
    Address1,
    Address2,
    City,
    Postcode,
    WorkHere
} Field;

@implementation AddVenueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setRightBarButton:@"Add" actionSelector:@selector(addVenue)];
    self.userData = [NSMutableDictionary dictionary];
    tableData = @[@"Name", @"Category", @"Address 1", @"Address 2", @"City", @"Postcode", @"Work here?"];
}

- (void)addVenue {
    self.navigationItem.rightBarButtonItem.enabled = NO;
    if ([self.userData[@(Name + 1)] length] > 0 && appDelegate.addVenueTypeId) {
        if ((workSwitch.on == YES && [appDelegate.venueDetailsContent[@(8)] length] > 0 && [appDelegate.venueDetailsContent[@(9)] length] > 0  && [appDelegate.venueDetailsContent[@(10)] length] > 0) || workSwitch.on == NO) {
            [self.view makeToastActivity];
            if (appDelegate.addVenueType) self.userData[@(Category + 1)] = appDelegate.addVenueType;

            if (workSwitch.on) {
                [self.userData addEntriesFromDictionary:appDelegate.venueDetailsContent];
            }

            [[[CLGeocoder alloc] init] reverseGeocodeLocation:man.location completionHandler:^(NSArray *placemark, NSError *error) {
                NSMutableArray *address = [NSMutableArray array];
                if (self.userData[@3] != nil) [address addObject:self.userData[@3]];
                if (self.userData[@4] != nil) [address addObject:self.userData[@4]];
                if (self.userData[@5] != nil) [address addObject:self.userData[@5]];
                if (self.userData[@6] != nil) [address addObject:self.userData[@6]];
                if ([address count] == 0) [address addObject:@""];

                NSMutableDictionary * params = [@{@"name": self.userData[@1],
                                                  @"category_id": appDelegate.addVenueTypeId,
                                                  @"address": [address componentsJoinedByString:@", "],
                                                  @"country": !error ? [((CLPlacemark *)placemark[0]).ISOcountryCode lowercaseString] : @"--",
                                                  @"lat": @(map.userLocation.coordinate.latitude),
                                                  @"lon": @(map.userLocation.coordinate.longitude),
                                                  @"creator_version": [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"]} mutableCopy];

                if (appDelegate.venueDetailsContent && workSwitch.on) {
                    if (appDelegate.venueDetailsContent[@(8)]) {
                        params[@"phone"] = appDelegate.venueDetailsContent[@(8)];
                    }
                    if (appDelegate.venueDetailsContent[@(9)]) {
                        params[@"email"] = appDelegate.venueDetailsContent[@(9)];
                    }
                    if (appDelegate.venueDetailsContent[@(10)]) {
                        params[@"website"] = appDelegate.venueDetailsContent[@(10)];
                    }
                }
                appDelegate.venueDetailsContent = nil;

                [Request post:@"venues/set" params:params callback:^(id response) {
                    if (response == nil) {
                        [self.view hideToastActivity];
                        [[[UIAlertView alloc] initWithTitle:@"Uh-oh.. Something went wrong.." message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                    } else {
                        if (workSwitch.on) {
                            [Request post:@"venue_managers/set" params:@{@"venue_id": response} callback:^(id response) {
                                [self.view hideToastActivity];
                                self.navigationItem.rightBarButtonItem.enabled = YES;
                                [self.navigationController popViewControllerAnimated:YES];
                            }];
                        } else {
                            [self.view hideToastActivity];
                            self.navigationItem.rightBarButtonItem.enabled = YES;
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                    }
                }];
            } ];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Fields Missing" message:@"Please fill in all required fields" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Fields Missing" message:@"Please fill in all required fields" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"Cell%ld", (long)indexPath.row ]];
    if (cell == nil) cell = [[UITableViewCell alloc] init];

    cell.textLabel.text = tableData[indexPath.row];

    UITextField *textField = (UITextField *)[cell viewWithTag:indexPath.row + 1];

    if (indexPath.row == Name) {
        if (!textField) {
            textField = [[UITextField alloc] initWithFrame:CGRectMake(110, 8, 185, 30)];
            textField.tag = indexPath.row + 1;
            textField.delegate = self;
            textField.autocorrectionType = UITextAutocorrectionTypeNo;
        }

        textField.placeholder = @"(Required)";
        [cell.contentView addSubview:textField];
    } else if (indexPath.row == Category) {
        UILabel *label = (UILabel *)[cell viewWithTag:indexPath.row + 1];
        if (!label) {
            label = [[UILabel alloc] initWithFrame:CGRectMake(110, 6, 185, 30)];
            label.text = @"(Required)";
            label.tag = indexPath.row + 1;
            label.textColor = [UIColor colorWithWhite:0.7 alpha:0.7];
            label.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:label];
            secondCellField = label;
            secondCell = cell;
        }
    } else if (indexPath.row == Address1) {
        if (!textField) {
            textField = [[UITextField alloc] initWithFrame:CGRectMake(110, 8, 185, 30)];
            textField.tag = indexPath.row + 1;
            textField.delegate = self;
            textField.autocorrectionType = UITextAutocorrectionTypeNo;
        }

        textField.placeholder = @"(Optional)";
        [cell.contentView addSubview:textField];
    } else if (indexPath.row == Address2) {
        if (!textField) {
            textField = [[UITextField alloc] initWithFrame:CGRectMake(110, 8, 185, 30)];
            textField.tag = indexPath.row + 1;
            textField.delegate = self;
            textField.autocorrectionType = UITextAutocorrectionTypeNo;
        }

        textField.placeholder = @"(Optional)";
        [cell.contentView addSubview:textField];
    } else if (indexPath.row == City) {
        if (!textField) {
            textField = [[UITextField alloc] initWithFrame:CGRectMake(110, 8, 185, 30)];
            textField.tag = indexPath.row + 1;
            textField.delegate = self;
            textField.autocorrectionType = UITextAutocorrectionTypeNo;
        }

        textField.placeholder = @"(Optional)";
        [cell.contentView addSubview:textField];
    } else if (indexPath.row == Postcode) {
        if (!textField) {
            textField = [[UITextField alloc] initWithFrame:CGRectMake(110, 8, 185, 30)];
            textField.tag = indexPath.row + 1;
            textField.delegate = self;
            textField.autocorrectionType = UITextAutocorrectionTypeNo;
        }

        textField.placeholder = @"(Optional)";
        [cell.contentView addSubview:textField];
    } else if (indexPath.row == WorkHere) {
        if (!textField) {
            textField = [[UITextField alloc] initWithFrame:CGRectMake(110, 6, 185, 30)];
            textField.tag = indexPath.row + 1;
            textField.delegate = self;
        }

        workSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(110, 6, 50, 30)];
        [workSwitch addTarget:self action:@selector(segwayToWork) forControlEvents:UIControlEventValueChanged];
        [cell.contentView addSubview:workSwitch];
    }

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [tableData count];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (appDelegate.addVenueType != nil) {
        secondCellField.text = appDelegate.addVenueType;
        secondCellField.textColor = [UIColor blackColor];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.userData[@(textField.tag)] = textField.text;
}

- (void)segwayToWork {
    if (workSwitch.on == YES) {
        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"VenueDetailsViewIdentifier"];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        appDelegate.venueDetailsContent = nil;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    secondCell.selected = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    appDelegate.addVenueType = nil;
}

- (void)initMap {
    self.navigationItem.rightBarButtonItem.enabled = NO;
    map = [[MKMapView alloc] initWithFrame:self.mapView.frame];
    map.delegate = self;
    man = [[CLLocationManager alloc] init];
    man.delegate = self;
    man.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    [man startUpdatingLocation];
    [self.mapView addSubview:map];
    [self.mapView sendSubviewToBack:map];
}

- (void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered {
    map.userTrackingMode = MKUserTrackingModeFollow;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [manager stopUpdatingLocation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [map removeFromSuperview];
    [man stopUpdatingLocation];
    man = nil;
    map = nil;
}

- (void)addBorder {
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, 70.0f, self.mapView.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor lightGrayColor].CGColor;
}

- (void)viewDidAppear:(BOOL)animated {
    [self addBorder];

    CALayer *topBorder = [CALayer layer];
    topBorder.frame = CGRectMake(0.0f, self.mapView.bounds.size.height - 1, self.mapView.frame.size.width, 1.0f);
    topBorder.backgroundColor = [UIColor lightGrayColor].CGColor;

    [self.mapView.layer addSublayer:topBorder];
    [self initMap];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.tag == Name + 1) {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 40) ? NO : YES;
    }
    return YES;
}

@end

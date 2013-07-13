//
//  AddVenueViewController.m
//  ShnergleApp
//
//  Created by Stian Johansen on 10/06/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "AddVenueViewController.h"
#import "PostRequest.h"
#import <Toast+UIView.h>

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
    self.navigationItem.title = @"Add Place";
    [self setRightBarButton:@"Add" actionSelector:@selector(addVenue)];

    tableData = @[@"Name", @"Category", @"Address 1", @"Address 2", @"City", @"Postcode", @"Work here?"];
}

- (void)addVenue {
    [self.view makeToastActivity];
    if (appDelegate.addVenueType) self.userData[Category + 1] = appDelegate.addVenueType;

    if (workSwitch.on) {
        [self.userData addObjectsFromArray:appDelegate.venueDetailsContent];
    }

    [[[CLGeocoder alloc]init] reverseGeocodeLocation:[[CLLocation alloc]initWithLatitude:marker.position.latitude longitude:marker.position.longitude] completionHandler:^(NSArray *placemark, NSError *error)
    {
        NSString *country;
        if (error) {
            country = @"--";
        } else {
            country = [((CLPlacemark *)placemark.firstObject).ISOcountryCode lowercaseString];
        }

        NSMutableString *params = [[NSMutableString alloc]initWithString:@"name="];
        [params appendString:self.userData[1]];
        [params appendString:@"&category_id="];
        [params appendString:appDelegate.addVenueTypeId];
        [params appendString:@"&address="];
        [params appendString:[NSString stringWithFormat:@"%@, %@, %@, %@", self.userData[3], self.userData[4], self.userData[5], self.userData[6]]];
        [params appendString:@"&country="];
        [params appendString:country];
        if (appDelegate.venueDetailsContent) {
            if (appDelegate.venueDetailsContent[0]) {
                [params appendString:@"&phone="];
                [params appendString:appDelegate.venueDetailsContent[0]];
            }
            if (appDelegate.venueDetailsContent[1]) {
                [params appendString:@"&email="];
                [params appendString:appDelegate.venueDetailsContent[1]];
            }
            if (appDelegate.venueDetailsContent[2]) {
                [params appendString:@"&website="];
                [params appendString:appDelegate.venueDetailsContent[2]];
            }
        }
        [params appendString:@"&lat="];
        [params appendFormat:@"%f", marker.position.latitude];
        [params appendString:@"&lon="];
        [params appendFormat:@"%f", marker.position.longitude];
        [params appendString:@"&timezone=0"];

        [[[PostRequest alloc]init]exec:@"venues/set" params:params delegate:self callback:@selector(didFinishAddingVenue:) type:@"string"];
    } ];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
}

- (void)didFinishAddingVenue:(NSString *)response {
    [self.view hideToastActivity];

    if (![response isEqual:@"true"]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Uh-oh.. Something went wrong.." message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }

    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"Cell%d", indexPath.row ]];
    if (cell == nil) cell = [[UITableViewCell alloc] init];

    cell.textLabel.text = tableData[indexPath.row];

    UITextField *textField = (UITextField *)[cell viewWithTag:indexPath.row + 1];

    if (indexPath.row == Name) {
        if (!textField) {
            textField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
            textField.tag = indexPath.row + 1;
            textField.delegate = self;
        }

        textField.placeholder = @"(Required)";
        [cell.contentView addSubview:textField];
    } else if (indexPath.row == Category) {
        UILabel *label = (UILabel *)[cell viewWithTag:indexPath.row + 1];
        if (!label) {
            label = [[UILabel alloc] initWithFrame:CGRectMake(110, 6, 185, 30)];
            label.text = @"(Required)";
            label.tag = indexPath.row + 1;
            label.textColor = [UIColor colorWithRed:201 / 255. green:201 / 255. blue:201 / 255. alpha:1];
            label.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:label];
            secondCellField = label;
            secondCell = cell;
        }
    } else if (indexPath.row == Address1) {
        if (!textField) {
            textField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
            textField.tag = indexPath.row + 1;
            textField.delegate = self;
        }

        textField.placeholder = @"(Optional)";
        [cell.contentView addSubview:textField];
    } else if (indexPath.row == Address2) {
        if (!textField) {
            textField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
            textField.tag = indexPath.row + 1;
            textField.delegate = self;
        }

        textField.placeholder = @"(Optional)";
        [cell.contentView addSubview:textField];
    } else if (indexPath.row == City) {
        if (!textField) {
            textField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
            textField.tag = indexPath.row + 1;
            textField.delegate = self;
        }

        textField.placeholder = @"(Optional)";
        [cell.contentView addSubview:textField];
    } else if (indexPath.row == Postcode) {
        if (!textField) {
            textField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
            textField.tag = indexPath.row + 1;
            textField.delegate = self;
        }

        textField.placeholder = @"(Optional)";
        [cell.contentView addSubview:textField];
    } else if (indexPath.row == WorkHere) {
        if (!textField) {
            textField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
            textField.tag = indexPath.row + 1;
            textField.delegate = self;
        }

        workSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(210, 8, 50, 30)];
        [workSwitch addTarget:self action:@selector(segwayToWork) forControlEvents:UIControlEventValueChanged];
        [cell.contentView addSubview:workSwitch];
    }

    return cell;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.placeholder = nil;
    textField.text = @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tableData.count;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (appDelegate.addVenueType != nil) {
        secondCellField.text = appDelegate.addVenueType;
        secondCellField.textColor = [UIColor blackColor];
    }
    [self initMap];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    self.userData[textField.tag] = textField.text;
}

- (void)segwayToWork {
    if (workSwitch.on == YES) {
        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"VenueDetailsViewIdentifier"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    secondCell.selected = NO;
}

- (void)goBack {
    appDelegate.addVenueType = nil;
    [super goBack];
}

- (void)initMap {
    hasPositionLocked = NO;
    map = [[GMSMapView alloc] initWithFrame:self.mapView.frame];
    map.myLocationEnabled = YES;
    map.delegate = self;
    [map addObserver:self forKeyPath:@"myLocation" options:NSKeyValueObservingOptionNew context:nil];
    [self.mapView addSubview:map];
    [self.mapView sendSubviewToBack:map];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (!hasPositionLocked) {
        if ([keyPath isEqualToString:@"myLocation"] && [object isKindOfClass:[GMSMapView class]]) {
            [map animateToCameraPosition:[GMSCameraPosition cameraWithLatitude:map.myLocation.coordinate.latitude longitude:map.myLocation.coordinate.longitude zoom:13]];

            [self mapView:map didTapAtCoordinate:map.myLocation.coordinate];
            venueCoord = map.myLocation.coordinate;

            hasPositionLocked = YES;
        }
    }
}

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    [mapView clear];
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude);
    marker = [GMSMarker markerWithPosition:position];
    marker.title = @"Selected venue location";
    marker.map = mapView;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [map removeObserver:self forKeyPath:@"myLocation" context:nil];
    [map clear];
    [map stopRendering];
    [map removeFromSuperview];
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
}

- (NSMutableArray *)userData {
    if (!self.userData) {
        self.userData = [[NSMutableArray alloc] initWithCapacity:[tableData count]];
        for (int i = 0; i < [tableData count]; i++) {
            [self.userData addObject:@""];
        }
    }
    return self.userData;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end

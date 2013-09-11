//
//  PhotoLocationViewController.m
//  ShnergleApp
//
//  Created by Stian Johansen on 3/22/13.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "PhotoLocationViewController.h"
#import "ShareViewController.h"
#import "Request.h"
#import <Toast/Toast+UIView.h>

@implementation PhotoLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    rows = 0;
    self.navigationItem.title = @"Location";
    venues = nil;
    [self.searchResultTable makeToastActivity];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self initMap];
}

- (void)didFinishLoadingVenues:(NSArray *)response {
    @synchronized (self) {
        venues = [response mutableCopy];
        locationPickerVenuesImmutable = [NSArray arrayWithArray:response];
        rows = [venues count] + 1;
        [self.searchResultTable reloadData];
        [self.searchResultTable hideToastActivity];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;

    appDelegate.addVenueCheckIn = NO;
}

- (IBAction)addVenueCheckIn:(id)sender {
    appDelegate.addVenueCheckIn = YES;
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddVenueViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;

    if (indexPath.row != [venues count]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        cell.textLabel.text = venues[indexPath.row][@"name"];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"AddVenueCell"];
        cell.textLabel.text = @"+ Add Place";
    }

    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font = [UIFont systemFontOfSize:20.0];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != [venues count]) appDelegate.activeVenue = venues[indexPath.row];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    venues = [NSMutableArray array];
    for (id obj in locationPickerVenuesImmutable) {
        if ([obj[@"name"] rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch].length > 0) {
            [venues addObject:obj];
        }
    }
    [self.searchResultTable reloadData];
    [searchBar resignFirstResponder];
}

- (void)initMap {
    hasPositionLocked = NO;
    man = [[CLLocationManager alloc] init];
    man.delegate = self;
    man.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    [man startUpdatingLocation];
    map = [[MKMapView alloc] initWithFrame:self.mapView.bounds];
    map.delegate = self;
    [self.mapView addSubview:map];
    [self.mapView sendSubviewToBack:map];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [map removeFromSuperview];
    map = nil;
}

- (void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered {
    map.userTrackingMode = MKUserTrackingModeFollow;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    if (!hasPositionLocked) {
        coord = ((CLLocation *)locations.lastObject).coordinate;
        MKCoordinateRegion rgn = MKCoordinateRegionMakeWithDistance(coord, 111, 11);
        double distanceInDegrees = sqrt(pow(rgn.span.latitudeDelta, 2) + pow(rgn.span.longitudeDelta, 2));

        NSDictionary *params = @{@"my_lat": @(coord.latitude),
                                 @"my_lon": @(coord.longitude),
                                 @"distance": @(distanceInDegrees),
                                 @"level": appDelegate.level};
        [Request post:@"venues/get" params:params delegate:self callback:@selector(didFinishLoadingVenues:)];

        hasPositionLocked = YES;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([@"SegueToShare" isEqualToString : segue.identifier]) {
        appDelegate.shnergleThis = YES;
    } else if ([@"AddVenueSegue" isEqualToString : segue.identifier]) {
        appDelegate.addVenueCheckIn = YES;
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

@end

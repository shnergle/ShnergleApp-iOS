//
//  PhotoLocationViewController.m
//  ShnergleApp
//
//  Created by Stian Johansen on 3/22/13.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "PhotoLocationViewController.h"
#import "ShareViewController.h"
#import "PostRequest.h"
#import <Toast/Toast+UIView.h>

@implementation PhotoLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Location";
    appDelegate.locationPickerVenues = nil;
    [self.searchResultTable makeToastActivity];
}


- (void)didFinishLoadingVenues:(NSArray *)response {
    appDelegate.locationPickerVenues = [NSMutableArray arrayWithArray:response];
    locationPickerVenuesImmutable = [NSArray arrayWithArray:response];
    [self.searchResultTable reloadData];
    [self.searchResultTable hideToastActivity];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self initMap];
    
    appDelegate.addVenueCheckIn = NO;
    
}

-(IBAction)addVenueCheckIn:(id)sender{
    appDelegate.addVenueCheckIn = YES;
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddVenueViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [appDelegate.locationPickerVenues count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;

    if (indexPath.row != [appDelegate.locationPickerVenues count]) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        cell.textLabel.text = appDelegate.locationPickerVenues[indexPath.row][@"name"];
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"AddVenueCell"];
        cell.textLabel.text = @"+ Add Place";
    }
    


    
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font = [UIFont systemFontOfSize:20.0];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    appDelegate.activeVenue = appDelegate.locationPickerVenues[indexPath.row];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    appDelegate.locationPickerVenues = [[NSMutableArray alloc] init];
    for (id obj in locationPickerVenuesImmutable) {
        if ([obj[@"name"] rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch].length > 0) {
            [appDelegate.locationPickerVenues addObject:obj];
        }
    }
    [self.searchResultTable reloadData];
    [searchBar resignFirstResponder];
}

- (void)initMap {
    hasPositionLocked = NO;
    map = [[GMSMapView alloc] initWithFrame:self.mapView.bounds];
    map.myLocationEnabled = YES;
    map.delegate = self;
    [map addObserver:self forKeyPath:@"myLocation" options:NSKeyValueObservingOptionNew context:nil];
    [self.mapView addSubview:map];
    [self.mapView sendSubviewToBack:map];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [map removeObserver:self forKeyPath:@"myLocation" context:nil];
    [map clear];
    [map stopRendering];
    [map removeFromSuperview];
    map = nil;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (!hasPositionLocked) {
        if ([keyPath isEqualToString:@"myLocation"] && [object isKindOfClass:[GMSMapView class]]) {
            coord = map.myLocation.coordinate;
            CGFloat screenDistance = [map.projection pointsForMeters:200 atCoordinate:coord];
            CGPoint screenCenter = [map.projection pointForCoordinate:coord];
            CGPoint screenPoint = CGPointMake(screenCenter.x - screenDistance, screenCenter.y);
            CLLocationCoordinate2D realPoint = [map.projection coordinateForPoint:screenPoint];
            CGFloat distanceInDegrees = coord.longitude - realPoint.longitude;
            [[[PostRequest alloc] init] exec:@"venues/get" params:[NSString stringWithFormat:@"my_lat=%f&my_lon=%f&distance=%f", coord.latitude, coord.longitude, distanceInDegrees] delegate:self callback:@selector(didFinishLoadingVenues:)];
            [map animateToCameraPosition:[GMSCameraPosition cameraWithLatitude:map.myLocation.coordinate.latitude longitude:map.myLocation.coordinate.longitude zoom:13]];

            hasPositionLocked = YES;
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([@"SegueToShare" isEqualToString:segue.identifier]) {
        //((ShareViewController *)[segue destinationViewController]).shnergleThis = YES;
        appDelegate.shnergleThis = YES;
    }
}



@end

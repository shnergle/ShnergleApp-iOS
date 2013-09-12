//
//  PhotoLocationViewController.h
//  ShnergleApp
//
//  Created by Stian Johansen on 3/22/13.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "CustomBackViewController.h"
#import <MapKit/MapKit.h>

@interface PhotoLocationViewController : CustomBackViewController <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, MKMapViewDelegate> {
    MKMapView *map;
    BOOL hasPositionLocked;
    CLLocationCoordinate2D coord;
    NSArray *locationPickerVenuesImmutable;
    NSUInteger rows;
    NSMutableArray *venues;
    CLLocationManager *man;
}

@property (weak, nonatomic) IBOutlet UILabel *headline;
@property (weak, nonatomic) IBOutlet UITableView *searchResultTable;
@property (weak, nonatomic) IBOutlet UIView *mapView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

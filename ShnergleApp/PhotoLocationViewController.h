//
//  PhotoLocationViewController.h
//  ShnergleApp
//
//  Created by Stian Johansen on 3/22/13.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "CustomBackViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface PhotoLocationViewController : CustomBackViewController <UISearchBarDelegate, GMSMapViewDelegate, UITableViewDelegate, UITableViewDataSource> {
    GMSMapView *map;
    BOOL hasPositionLocked;
    CLLocationCoordinate2D coord;
    NSArray *locationPickerVenuesImmutable;
    int rows;
}

@property (weak, nonatomic) IBOutlet UILabel *headline;
@property (weak, nonatomic) IBOutlet UITableView *searchResultTable;
@property (weak, nonatomic) IBOutlet UIView *mapView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

//
//  PhotoLocationViewController.h
//  ShnergleApp
//
//  Created by Stian Johansen on 3/22/13.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomBackViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface PhotoLocationViewController : CustomBackViewController <UISearchBarDelegate, GMSMapViewDelegate> {
    GMSMapView *map;
    BOOL hasPositionLocked;
}

@property (weak, nonatomic) IBOutlet UILabel *headline;
@property (weak, nonatomic) IBOutlet UITableView *searchResultTable;
@property (strong, nonatomic) NSArray *tableData;
@property (weak, nonatomic) IBOutlet UIView *mapView;


@end

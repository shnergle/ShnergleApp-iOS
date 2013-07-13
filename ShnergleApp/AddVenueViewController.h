//
//  AddVenueViewController.h
//  ShnergleApp
//
//  Created by Stian Johansen on 10/06/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "CustomBackViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface AddVenueViewController : CustomBackViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, GMSMapViewDelegate, UIAlertViewDelegate>
{
    UITableViewCell *secondCell;
    UILabel *secondCellField;
    bool hasPositionLocked;
    CLLocationCoordinate2D venueCoord;
    GMSMapView *map;
    GMSMarker *marker;
    NSArray *tableData;
    UISwitch *workSwitch;
}
@property (weak, nonatomic) IBOutlet UIView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *userData;
@end

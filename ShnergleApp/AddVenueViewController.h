//
//  AddVenueViewController.h
//  ShnergleApp
//
//  Created by Stian Johansen on 10/06/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "CustomBackViewController.h"
#import <MapKit/MapKit.h>

@interface AddVenueViewController : CustomBackViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, MKMapViewDelegate, UIAlertViewDelegate, CLLocationManagerDelegate>
{
    UITableViewCell *secondCell;
    UILabel *secondCellField;
    CLLocationCoordinate2D venueCoord;
    MKMapView *map;
    NSArray *tableData;
    UISwitch *workSwitch;
    CLLocationManager *man;
}
@property (weak, nonatomic) IBOutlet UIView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableDictionary *userData;
@end

//
//  AddVenueViewController.h
//  ShnergleApp
//
//  Created by Stian Johansen on 10/06/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomBackViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface AddVenueViewController : CustomBackViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,GMSMapViewDelegate>
{
    UITableViewCell *secondCell;
    UILabel *secondCellField;
    bool hasPositionLocked;
    
}
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *tableData;
@property (weak, nonatomic) UISwitch *workSwitch;
@end

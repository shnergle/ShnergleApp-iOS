//
//  AnalyticsViewController.h
//  ShnergleApp
//
//  Created by Harshita Balaga on 06/08/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "CustomBackViewController.h"

@interface AnalyticsViewController : CustomBackViewController <UITableViewDelegate, UITableViewDataSource> {
    NSArray *tableData;
}

@end

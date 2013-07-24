//
//  selectPromotionsViewController.h
//  ShnergleApp
//
//  Created by Stian Johansen on 24/07/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomBackViewController.h"

@interface selectPromotionsViewController : CustomBackViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *promotions;
    NSIndexPath *selectedIndexPath;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

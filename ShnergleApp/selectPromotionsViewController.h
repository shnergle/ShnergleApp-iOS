//
//  selectPromotionsViewController.h
//  ShnergleApp
//
//  Created by Stian Johansen on 24/07/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface selectPromotionsViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *tableData;
}

@end

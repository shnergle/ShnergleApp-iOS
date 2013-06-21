//
//  VenueCategoryViewController.h
//  ShnergleApp
//
//  Created by Stian Johansen on 10/06/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "CustomBackViewController.h"

@interface VenueCategoryViewController : CustomBackViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *categories;
}
@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;

@end

//
//  MenuViewController.h
//  Consumer App
//
//  Created by Stian Johansen on 11/05/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import<FacebookSDK/FacebookSDK.h>
#import "SearchBarView.h"

@interface MenuViewController : UIViewController <UITableViewDataSource>
{
    NSArray *tableData;
}

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak,nonatomic) IBOutlet SearchBarView *searchBar;
- (IBAction)tapProfile:(id)sender;

@end

//
//  HeaderTableView.m
//  ShnergleApp
//
//  Created by Harshita Balaga on 07/06/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "HeaderTableView.h"

@implementation HeaderTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (UITableViewHeaderFooterView *)headerViewForSection:(NSInteger)section
{
    NSLog(@"Something %@", [self.dataSource tableView:self titleForHeaderInSection:section]);
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    headerLabel.backgroundColor = [UIColor colorWithRed:29 green:29 blue:29 alpha:1];
    headerLabel.text = [self.dataSource tableView:self titleForHeaderInSection:section];
    headerLabel.textColor = [UIColor colorWithRed:117 green:117 blue:117 alpha:1];
    return (UITableViewHeaderFooterView *)headerLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

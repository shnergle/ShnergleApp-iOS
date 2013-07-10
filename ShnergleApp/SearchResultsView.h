//
//  SearchResultsView.h
//  ShnergleApp
//
//  Created by Stian Johansen on 17/06/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

@interface SearchResultsView : UIView

@property (weak, nonatomic) IBOutlet UITableView *resultsTableView;

- (void)hide;
- (void)show;
@end

//
//  SearchResultsView.m
//  ShnergleApp
//
//  Created by Stian Johansen on 17/06/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "SearchResultsView.h"

@implementation SearchResultsView

- (void)hide {
    [UIView animateWithDuration:0.5
                     animations:^{
        self.frame = CGRectMake(320,
                                self.frame.origin.y,
                                self.frame.size.width,
                                self.frame.size.height);
    }];
}

- (void)show {
    [UIView animateWithDuration:0.5
                     animations:^{
        self.frame = CGRectMake(0,
                                self.frame.origin.y,
                                self.frame.size.width,
                                self.frame.size.height + 25);
    }];
}

@end

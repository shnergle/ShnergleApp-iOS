//
//  CustomerCheckIns.m
//  ShnergleApp
//
//  Created by Harshita Balaga on 11/09/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "CustomerCheckIns.h"

@implementation CustomerCheckIns

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = @"Customers Checking In";
}

- (IBAction)date:(id)sender {
    NSLog(@"start");
    if (self.pickerView.superview == nil) {
        NSLog(@"Stop");
        CGRect startFrame = self.pickerView.frame;
        CGRect endFrame = self.pickerView.frame;
        NSLog(@"%@", self.pickerView);
        startFrame.origin.y = self.view.frame.size.height;
        endFrame.origin.y = startFrame.origin.y - endFrame.size.height;

        self.pickerView.frame = startFrame;

        [self.view addSubview:self.pickerView];
        NSLog(@"start frame %f %f %f %f", startFrame.origin.x, startFrame.origin.y, startFrame.size.width, startFrame.size.height);
        NSLog(@"start frame %f %f %f %f", endFrame.origin.x, endFrame.origin.y, endFrame.size.width, endFrame.size.height);

        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.40];
        self.pickerView.frame = endFrame;
        [UIView commitAnimations];

        //publishButton = self.navigationItem.rightBarButtonItem;

        //self.navigationItem.rightBarButtonItem = self.doneButton;
    }
}

@end

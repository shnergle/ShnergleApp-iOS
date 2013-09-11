//
//  CustomerCheckIns.m
//  ShnergleApp
//
//  Created by Harshita Balaga on 11/09/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "CustomerCheckIns.h"

@interface CustomerCheckIns ()

@end

@implementation CustomerCheckIns

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.title = @"Customers Checking In";
}

-(IBAction)date:(id)sender{
    NSLog(@"start");
    if (self.pickerView.superview == nil) {
        NSLog(@"Stop");
        CGRect startFrame = self.pickerView.frame;
        CGRect endFrame = self.pickerView.frame;
        startFrame.origin.y = self.view.frame.size.height;
        endFrame.origin.y = startFrame.origin.y - endFrame.size.height;
        
        self.pickerView.frame = startFrame;
        
        [self.view addSubview:self.pickerView];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.40];
        self.pickerView.frame = endFrame;
        [UIView commitAnimations];
        
        //publishButton = self.navigationItem.rightBarButtonItem;
        
        //self.navigationItem.rightBarButtonItem = self.doneButton;
    }

    
}

@end

//
//  CheckInViewController.m
//  ShnergleApp
//
//  Created by Stian Johansen on 3/21/13.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "CheckInViewController.h"
#import "AppDelegate.h"
#import <UIImage+Resize.h>

@implementation CheckInViewController


- (void)takePhoto {
    imgPickerCam = [[UIImagePickerController alloc] init];
    imgPickerCam.delegate = self;
    [imgPickerCam setSourceType:UIImagePickerControllerSourceTypeCamera];
    [self presentViewController:imgPickerCam animated:NO completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    taken = YES;
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.shareImage = [info[@"UIImagePickerControllerOriginalImage"] resizedImageToFitInSize:CGSizeMake(200, 200) scaleIfSmaller:YES];
    info = nil;
    [imgPickerCam dismissViewControllerAnimated:NO completion:nil];
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoLocationViewController"];
    taken = NO;
    [imgPickerCam dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [imgPickerCam dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    taken = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!taken) {
        [self takePhoto];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

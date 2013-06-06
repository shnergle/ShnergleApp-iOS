//
//  CheckInViewController.m
//  ShnergleApp
//
//  Created by Stian Johansen on 3/21/13.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "CheckInViewController.h"
#import "AppDelegate.h"

@implementation CheckInViewController


- (void)takePhoto {
    imgPickerCam = [[UIImagePickerController alloc] init];
    imgPickerCam.delegate = self;
    [imgPickerCam setSourceType:UIImagePickerControllerSourceTypeCamera];
    [self presentViewController:imgPickerCam animated:NO completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.shareImage = info[@"UIImagePickerControllerOriginalImage"];
    [imgPickerCam dismissViewControllerAnimated:NO completion:nil];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"PhotoLocationViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [imgPickerCam dismissViewControllerAnimated:YES completion:nil];
    [self goBack];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self takePhoto];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

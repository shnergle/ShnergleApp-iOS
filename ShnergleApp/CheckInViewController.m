//
//  CheckInViewController.m
//  ShnergleApp
//
//  Created by Stian Johansen on 3/21/13.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "CheckInViewController.h"
#import <UIImage+Resize.h>

@implementation CheckInViewController

- (void)takePhoto {
    imgPickerCam = [[UIImagePickerController alloc] init];
    imgPickerCam.delegate = self;
    [imgPickerCam setSourceType:UIImagePickerControllerSourceTypeCamera];
    [self presentViewController:imgPickerCam animated:NO completion:nil];
}

- (void)useImage:(UIImage *)img {
    NSDictionary *info;
    if (appDelegate.saveLocally) {
        UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
    }
    appDelegate.shareImage = [img resizedImageToFitInSize:CGSizeMake(200, 200) scaleIfSmaller:YES];
    info = nil;
    UIViewController *vc;
    if (!appDelegate.activeVenue) {
        vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoLocationViewController"];
    } else {
        vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ShareViewController"];
    }
    taken = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        [imgPickerCam dismissViewControllerAnimated:YES completion:nil];
    });
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    taken = YES;

    UIImage *img = info[@"UIImagePickerControllerOriginalImage"];
    [NSThread detachNewThreadSelector:@selector(useImage:) toTarget:self withObject:img];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [imgPickerCam dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    taken = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!taken) {
        [self takePhoto];
    }
}

@end

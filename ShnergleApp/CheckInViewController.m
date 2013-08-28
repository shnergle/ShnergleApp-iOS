//
//  CheckInViewController.m
//  ShnergleApp
//
//  Created by Stian Johansen on 3/21/13.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "CheckInViewController.h"
#import "UIImage+Resize.h"
#import "Request.h"

@implementation CheckInViewController

- (void)takePhoto {
    imgPickerCam = [[UIImagePickerController alloc] init];
    imgPickerCam.delegate = self;
    imgPickerCam.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:imgPickerCam animated:NO completion:nil];
}

- (void)useImage:(UIImage *)img {
    NSDictionary *info;
    if (appDelegate.saveLocally) {
        UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
    }
    [Request setImage:@{@"entity": @"image", @"entity_id": @"toShare"} image:[img resizedImageToFitInSize:CGSizeMake(200, 200) scaleIfSmaller:YES]];
    info = nil;
    UIViewController *vc;
    if (!appDelegate.activeVenue) {
        vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoLocationViewController"];
    } else {
        vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ShareViewController"];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [imgPickerCam dismissViewControllerAnimated:YES completion:^{
            [self.navigationController pushViewController:vc animated:YES];
            taken = NO;
        }];
    });
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    taken = YES;

    UIImage *img = info[@"UIImagePickerControllerOriginalImage"];
    [NSThread detachNewThreadSelector:@selector(useImage:) toTarget:self withObject:img];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    taken = YES;
    [imgPickerCam dismissViewControllerAnimated:YES completion:^{
        [self.navigationController popViewControllerAnimated:YES];
        taken = NO;
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    taken = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!taken) {
        [self takePhoto];
    }
}

@end

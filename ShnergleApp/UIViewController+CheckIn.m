//
//  UIViewController+CheckIn.m
//  ShnergleApp
//
//  Created by Stian Johansen on 3/21/13.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "UIViewController+CheckIn.h"
#import <UIImage-Resize/UIImage+Resize.h>
#import "Request.h"
#import <FlurrySDK/Flurry.h>

@implementation UIViewController (CheckIn)

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *img = info[@"UIImagePickerControllerOriginalImage"];
    if (appDelegate.saveLocally) {
        UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
    }
    [Request setImage:@{@"entity": @"image", @"entity_id": @"toShare"} image:[img resizedImageToFitInSize:CGSizeMake(612, 612) scaleIfSmaller:YES]];
    info = nil;
    UIViewController *vc;
    UIStoryboard *storyboard = self.storyboard ? self.storyboard : [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    if (!appDelegate.activeVenue) {
        vc = [storyboard instantiateViewControllerWithIdentifier:@"PhotoLocationViewController"];
    } else {
        vc = [storyboard instantiateViewControllerWithIdentifier:@"ShareViewController"];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [picker dismissViewControllerAnimated:NO completion:^{
            [self.navigationController pushViewController:vc animated:YES];
        }];
    });
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)presentCheckInFlow:(id)sender {
    [Flurry logEvent:@"Started checking in" withParameters:@{@"view": NSStringFromClass([self class])}];
    appDelegate.shareVenue = NO;
    appDelegate.shnergleThis = YES;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:nil];
}

@end

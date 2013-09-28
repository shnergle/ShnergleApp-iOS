//
//  PromotionView.m
//  ShnergleApp
//
//  Created by Stian Johansen on 19/4/13.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "PromotionView.h"
#import "Request.h"
#import <UIImage-Resize/UIImage+Resize.h>

@implementation PromotionView

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = @"Promotion";
}

- (void)viewDidLoad {
    man = [[CLLocationManager alloc] init];
    man.delegate = self;
    man.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    [man startUpdatingLocation];
    if (!appDelegate.canRedeem) {
        [self.redeemButton setTitle:@"Redeemed" forState:UIControlStateNormal];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    BOOL on = [((CLLocation *)locations.lastObject)distanceFromLocation :[[CLLocation alloc] initWithLatitude:[appDelegate.activeVenue[@"lat"] doubleValue] longitude:[appDelegate.activeVenue[@"lon"] doubleValue]]] <= 111;

    if (appDelegate.canRedeem) self.redeemButton.enabled = on;
}

- (IBAction)tapUseDeal:(id)sender {
    appDelegate.redeeming = [appDelegate.activePromotion[@"id"] stringValue];
    [self presentCheckInFlow:nil];
}

- (void)setpromotionTitle:(NSString *)contents {
    self.promotionTitle.text = contents;
    self.promotionTitle.font = [UIFont systemFontOfSize:self.promotionTitle.font.pointSize];
    self.promotionTitle.textAlignment = NSTextAlignmentCenter;
}

- (void)setpromotionBody:(NSString *)contents {
    self.promotionBody.text = contents;
    self.promotionBody.font = [UIFont systemFontOfSize:self.promotionBody.font.pointSize];
    self.promotionBody.textColor = [UIColor whiteColor];
    self.promotionBody.textAlignment = NSTextAlignmentCenter;
}

- (void)setpromotionExpiry:(NSString *)contents {
    self.promotionExpiry.text = contents;
    self.promotionExpiry.font = [UIFont systemFontOfSize:self.promotionExpiry.font.pointSize];
    self.promotionExpiry.textAlignment = NSTextAlignmentCenter;
}

- (void)setpromotionClaimed:(NSString *)contents {
    self.promotionClaimed.text = contents;
    self.promotionClaimed.font = [UIFont systemFontOfSize:self.promotionClaimed.font.pointSize];
    self.promotionClaimed.textAlignment = NSTextAlignmentCenter;
}

- (void)setpromotionLevel:(NSString *)contents {
    self.promotionLevel.text = contents;
    self.promotionLevel.font = [UIFont systemFontOfSize:self.promotionLevel.font.pointSize];
    self.promotionLevel.textAlignment = NSTextAlignmentCenter;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
#warning pseudo code
    if (false /*notRedeeming*/) appDelegate.redeeming = nil;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *img = info[@"UIImagePickerControllerOriginalImage"];
    if (appDelegate.saveLocally) {
        UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
    }
    [Request setImage:@{@"entity": @"image", @"entity_id": @"toShare"} image:[img resizedImageToFitInSize:CGSizeMake(612, 612) scaleIfSmaller:YES]];
    info = nil;
    UIViewController *vc;
    if (!appDelegate.activeVenue) {
        vc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"PhotoLocationViewController"];
    } else {
        vc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"ShareViewController"];
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
    appDelegate.shareVenue = NO;
    appDelegate.shnergleThis = YES;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:nil];
}

@end

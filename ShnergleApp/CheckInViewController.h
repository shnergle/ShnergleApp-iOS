//
//  CheckInViewController.h
//  ShnergleApp
//
//  Created by Stian Johansen on 3/21/13.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckInViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIImagePickerController *imgPickerCam;
    UIImagePickerController *imgPickerLib;
    IBOutlet UIImageView *imageView;
    BOOL taken;
}


@end

//
//  CheckInViewController.h
//  Consumer App
//
//  Created by Stian Johansen on 3/21/13.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckInViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIImagePickerController *imgPickerCam;
    UIImagePickerController *imgPickerLib;
    UIImage *image;
    IBOutlet UIImageView *imageView;
}

-(IBAction)TakePhoto;
-(IBAction)ChooseExisting;


@end

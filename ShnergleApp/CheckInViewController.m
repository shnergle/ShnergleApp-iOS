//
//  CheckInViewController.m
//  ShnergleApp
//
//  Created by Stian Johansen on 3/21/13.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "CheckInViewController.h"

@implementation CheckInViewController


-(IBAction)TakePhoto
{
    imgPickerCam = [[UIImagePickerController alloc] init];
    imgPickerCam.delegate = self;
    [imgPickerCam setSourceType:UIImagePickerControllerSourceTypeCamera];
    [self presentViewController:imgPickerCam animated:YES completion:NULL];
    //[imgPickerCam release]; //Nevermind for automatic ref counting.
}

-(IBAction)ChooseExisting
{
    imgPickerLib = [[UIImagePickerController alloc] init];
    imgPickerLib.delegate = self;
    [imgPickerLib setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:imgPickerLib animated:YES completion:NULL];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [imageView setImage:image];
    //dismissal removed, not for auto ref counting.
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

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
    self.navigationController.navigationBarHidden = NO;
    UIBarButtonItem *menuButton;
    menuButton = [self createLeftBarButton:@"arrow_west" actionSelector:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = menuButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIBarButtonItem *)createLeftBarButton:(NSString *)imageName actionSelector:(SEL)actionSelector
{
    UIImage *menuButtonImg = [UIImage imageNamed:imageName];
    
    UIButton *menuButtonTmp = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButtonTmp.frame = CGRectMake(280.0, 10.0, 19.0, 16.0);
    [menuButtonTmp setBackgroundImage:menuButtonImg forState:UIControlStateNormal];
    [menuButtonTmp addTarget:self action:actionSelector forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc]initWithCustomView:menuButtonTmp];
    return menuButton;
}

//workaround to get the custom back button to work
- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end

//
//  AppDelegate.h
//  Consumer App
//
//  Created by Stian Johansen on 3/21/13.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//
// Note: Icons http://www.glyphish.com/

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <FacebookSDK/FacebookSDK.h>

@class LoginScreenController;


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIViewController *viewcont;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LoginScreenController *viewController;


@property (strong, nonatomic) FBSession *session;
@property (strong, nonatomic) NSString *fullName;

@end

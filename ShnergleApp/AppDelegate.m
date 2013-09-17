//
//  AppDelegate.m
//  ShnergleApp
//
//  Created by Stian Johansen on 3/21/13.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "LoginScreenController.h"
#import <Crashlytics/Crashlytics.h>
#import <FacebookSDK/FBAppCall.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    openURL:(NSURL *)url
    sourceApplication:(NSString *)sourceApplication
    annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[FBSession activeSession] close];
}

- (void)customiseNavBar {
    [[UINavigationBar appearance] setTitleTextAttributes:
     @{NSForegroundColorAttributeName: [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0],
       NSFontAttributeName: [UIFont systemFontOfSize:20.0]}];

    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:233.0 / 255 green:235.0 / 255 blue:240.0 / 255 alpha:1.0]];
    [[UINavigationBar appearance] setBackgroundColor:[UIColor colorWithRed:233.0 / 255 green:235.0 / 255 blue:240.0 / 255 alpha:1.0]];

    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor]} forState:UIControlStateNormal];

    NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};

    [[UIBarButtonItem appearance] setTitleTextAttributes:attributes
                                                forState:UIControlStateNormal];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self customiseNavBar];

    [Crashlytics startWithAPIKey:@"2baf430bbb573cfdb444a30b0058c3d474393497"];

    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBAppCall handleDidBecomeActive];
}

@end

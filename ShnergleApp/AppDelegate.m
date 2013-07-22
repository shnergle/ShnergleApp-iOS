//
//  AppDelegate.m
//  ShnergleApp
//
//  Created by Stian Johansen on 3/21/13.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "LoginScreenController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <Crashlytics/Crashlytics.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    openURL:(NSURL *)url
    sourceApplication:(NSString *)sourceApplication
    annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:self.session];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [self.session close];
}

- (void)customiseNavBar {
    [[UINavigationBar appearance] setTitleTextAttributes:
     @{UITextAttributeTextColor: [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0],
       UITextAttributeTextShadowColor: [UIColor clearColor],
       UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, 0)],
       UITextAttributeFont: [UIFont systemFontOfSize:20.0]}];

    @try {
        [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:233.0 / 255 green:235.0 / 255 blue:240.0 / 255 alpha:1.0]];
    } @catch (NSException *exception) {
    }
    [[UINavigationBar appearance] setBackgroundColor:[UIColor colorWithRed:233.0 / 255 green:235.0 / 255 blue:240.0 / 255 alpha:1.0]]; //ios 7

    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:@{UITextAttributeTextColor: [UIColor blackColor]} forState:UIControlStateNormal];

    NSDictionary *attributes = @{UITextAttributeTextColor: [UIColor whiteColor],
                                 UITextAttributeTextShadowColor: [UIColor clearColor]};

    [[UIBarButtonItem appearance] setTitleTextAttributes:attributes
                                                forState:UIControlStateNormal];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self customiseNavBar];

    [GMSServices provideAPIKey:@"AIzaSyBiJeQvT0FUQdGPMbOR8DFGdVbEtHMJe7c"];
    self.appSecret = @"FCuf65iuOUDCjlbiyyer678Coutyc64v655478VGvgh76";

    [Crashlytics startWithAPIKey:@"2baf430bbb573cfdb444a30b0058c3d474393497"];

    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBAppCall handleDidBecomeActiveWithSession:self.session];
}

@end

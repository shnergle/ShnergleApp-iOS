//
//  AppDelegate.h
//  ShnergleApp
//
//  Created by Stian Johansen on 3/21/13.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

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
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *facebookId;
@property (strong, nonatomic) NSString *appSecret;
@property (strong, nonatomic) NSString *twitter;

@property (strong, nonatomic) NSArray *images;
@property (strong, nonatomic) NSArray *venueNames;

@property (strong, nonatomic) UIImage *shareImage;

@property (strong, nonatomic) NSString *topViewType;

@property (strong, nonatomic) NSString *addVenueType;

@property (strong, nonatomic) NSMutableArray *searchResults;


typedef NS_ENUM (NSInteger, VENUE_STATUS) {
    Default,
    Following,
    Staff,
    Manager,
    None
};

@property (nonatomic) VENUE_STATUS venueStatus;

@property (strong, nonatomic) NSString *staffType;

@end

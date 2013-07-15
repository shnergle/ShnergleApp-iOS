//
//  AppDelegate.h
//  ShnergleApp
//
//  Created by Stian Johansen on 3/21/13.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) FBSession *session;
@property (strong, nonatomic) NSString *fullName;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *facebookId;
@property (strong, nonatomic) NSString *appSecret;
@property (strong, nonatomic) NSString *twitter;
@property (nonatomic) BOOL saveLocally;
@property (nonatomic) BOOL optInTop5;

@property (strong, nonatomic) NSArray *posts;
@property (strong, nonatomic) NSArray *aroundVenues;
@property (strong, nonatomic) NSArray *followingVenues;
@property (strong, nonatomic) NSMutableArray *locationPickerVenues;

@property (nonatomic) BOOL shareVenue;

@property (strong, nonatomic) UIImage *shareImage;
@property (strong, nonatomic) NSString *shareActivePostId;

@property (nonatomic) BOOL backFromShareView;
@property (strong, nonatomic) NSString *topViewType;

@property (strong, nonatomic) NSString *addVenueType;
@property (strong, nonatomic) NSString *addVenueTypeId;
@property (strong, nonatomic) NSMutableArray *venueDetailsContent;

@property (strong, nonatomic) NSDictionary *activeVenue;

@property (strong, nonatomic) NSMutableArray *searchResults;

@property (strong, nonatomic) id didShare;

typedef NS_ENUM (NSInteger, VENUE_STATUS) {
    Default,
    Staff,
    Manager
};

@property (nonatomic) VENUE_STATUS venueStatus;

@property (strong, nonatomic) NSDictionary *staff;
@property (strong, nonatomic) NSString *staffType;

@end

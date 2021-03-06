//
//  AppDelegate.h
//  ShnergleApp
//
//  Created by Stian Johansen on 3/21/13.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSString *fullName;
@property (strong, nonatomic) NSString *facebookId;
@property (strong, nonatomic) NSString *twitter;
@property (nonatomic) BOOL employee;
@property (nonatomic) BOOL saveLocally;
@property (nonatomic) BOOL optInTop5;
@property (nonatomic) BOOL lastFb;
@property (nonatomic) BOOL lastTwitter;

@property (strong, nonatomic) NSString *youShare;
@property (strong, nonatomic) NSString *checkIn;
@property (strong, nonatomic) NSString *comment;
@property (strong, nonatomic) NSString *like;
@property (strong, nonatomic) NSString *totalScore;


@property (nonatomic) BOOL shareVenue;
@property (nonatomic) BOOL shnergleThis;

@property (strong, nonatomic) NSString *shareActivePostId;

@property (nonatomic) BOOL backFromShareView;
@property (strong, nonatomic) NSString *topViewType;

@property (strong, nonatomic) NSString *addVenueType;
@property (strong, nonatomic) NSString *addVenueTypeId;
@property (strong, nonatomic) NSMutableDictionary *venueDetailsContent;

@property (strong, nonatomic) NSDictionary *activeVenue;
@property (strong, nonatomic) NSArray *ownVenues;
@property (strong, nonatomic) NSDictionary *activePromotion;
@property (nonatomic) BOOL canRedeem;

@property (nonatomic) BOOL claiming;

@property (strong, nonatomic) NSString *level;
@property (nonatomic) int audience;

@property (nonatomic) NSString *redeeming;

typedef NS_ENUM (NSInteger, VENUE_STATUS) {
    Default,
    Staff,
    Manager,
    UnverifiedManager
};

@property (nonatomic) VENUE_STATUS venueStatus;

@property (strong, nonatomic) NSDictionary *staff;
@property (strong, nonatomic) NSString *staffType;

@property (nonatomic) BOOL addVenueCheckIn;

@end

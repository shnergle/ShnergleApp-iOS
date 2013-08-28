//
//  PostRequest.h
//  ShnergleApp
//
//  Created by Adam Hani Schakaki on 01/06/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

@interface Request : NSObject

typedef NS_ENUM (NSInteger, TYPE) {
    String,
    Image,
    JSON
};

+ (UIImage *)getImage:(NSDictionary *)params;
+ (void)setImage:(NSDictionary *)params image:(UIImage *)image;

+ (void)post:(NSString *)path params:(NSDictionary *)params delegate:(id)object callback:(SEL)cb;
+ (void)post:(NSString *)path params:(NSDictionary *)params delegate:(id)object callback:(SEL)cb type:(TYPE)type;
+ (void)post:(NSString *)path params:(NSDictionary *)params image:(UIImage *)image delegate:(id)object callback:(SEL)cb;
+ (void)post:(NSString *)path params:(NSDictionary *)params image:(UIImage *)image delegate:(id)object callback:(SEL)cb type:(TYPE)type;
+ (void)post:(NSString *)path params:(NSDictionary *)params delegate:(id)object callback:(SEL)cb userData:(id)userData;
+ (void)post:(NSString *)path params:(NSDictionary *)params delegate:(id)object callback:(SEL)cb type:(TYPE)type userData:(id)userData;
+ (void)post:(NSString *)path params:(NSDictionary *)params image:(UIImage *)image delegate:(id)object callback:(SEL)cb userData:(id)userData;
+ (void)post:(NSString *)path params:(NSDictionary *)params image:(UIImage *)image delegate:(id)object callback:(SEL)cb type:(TYPE)type userData:(id)userData;

@end

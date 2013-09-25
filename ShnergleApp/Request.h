//
//  Request.h
//  ShnergleApp
//
//  Created by Adam Hani Schakaki on 01/06/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

@interface Request : NSObject

+ (UIImage *)getImage:(NSDictionary *)params;
+ (void)setImage:(NSDictionary *)params image:(UIImage *)image;
+ (void)removeImage:(NSDictionary *)params;
+ (void)post:(NSString *)path params:(NSDictionary *)params callback:(void(^)(id))callback;
+ (int)time:(BOOL)nextSix;

@end

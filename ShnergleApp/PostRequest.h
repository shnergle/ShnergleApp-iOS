//
//  PostRequest.h
//  ShnergleApp
//
//  Created by Adam Hani Schakaki on 01/06/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

@interface PostRequest : NSObject <NSURLConnectionDelegate> {
    NSMutableData *response;
    id responseObject;
    SEL responseCallback;
    NSString *responseType;
}

- (BOOL)exec:(NSString *)path params:(NSDictionary *)params delegate:(id)object callback:(SEL)cb;

- (BOOL)exec:(NSString *)path params:(NSDictionary *)params delegate:(id)object callback:(SEL)cb type:(NSString *)type;

- (BOOL)exec:(NSString *)path params:(NSDictionary *)params image:(UIImage *)image delegate:(id)object callback:(SEL)cb;

- (BOOL)exec:(NSString *)path params:(NSDictionary *)params image:(UIImage *)image delegate:(id)object callback:(SEL)cb type:(NSString *)type;

@end

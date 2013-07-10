//
//  PostRequest.h
//  ShnergleApp
//
//  Created by Adam Hani Schakaki on 01/06/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "CrowdItem.h"

@interface PostRequest : NSObject <NSURLConnectionDelegate> {
    NSMutableData *response;
    id responseObject;
    SEL responseCallback;
    NSString *responseType;
    CrowdItem *item;
}

- (BOOL)exec:(NSString *)path params:(NSString *)params delegate:(id)object callback:(SEL)cb;

- (BOOL)exec:(NSString *)path params:(NSString *)params delegate:(id)object callback:(SEL)cb type:(NSString *)type;

- (BOOL)exec:(NSString *)path params:(NSString *)params image:(UIImage *)image delegate:(id)object callback:(SEL)cb;

- (BOOL)exec:(NSString *)path params:(NSString *)params image:(UIImage *)image delegate:(id)object callback:(SEL)cb type:(NSString *)type;

- (BOOL)exec:(NSString *)path params:(NSString *)params delegate:(id)object callback:(SEL)cb item:(CrowdItem *)tItem;

- (BOOL)exec:(NSString *)path params:(NSString *)params delegate:(id)object callback:(SEL)cb type:(NSString *)type item:(CrowdItem *)tItem;

@end

//
//  PostRequest.h
//  ShnergleApp
//
//  Created by Adam Hani Schakaki on 01/06/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostRequest : NSObject <NSURLConnectionDelegate> {
    NSMutableData *response;
    id responseObject;
    SEL responseCallback;
    NSString *responseType;
}

- (void)exec:(NSString *)path params:(NSString *)params delegate:(id)object callback:(SEL)cb;

- (void)exec:(NSString *)path params:(NSString *)params delegate:(id)object callback:(SEL)cb type:(NSString *)type;

@end

//
//  ImageCache.m
//  ShnergleApp
//
//  Created by Adam Hani Schakaki on 02/06/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "ImageCache.h"
#import "PostRequest.h"

@implementation ImageCache

- (id)init {
    self = [super init];
    if (self != nil) {
        cache = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)get:(NSString *)type id:(NSString *)type_id delegate:(id)object callback:(SEL)cb {
    responseObject = object;
    responseCallback = cb;
    key = [NSString stringWithFormat:@"%@/%@", type, type_id];
    id obj;
    if ((obj = cache[key]) != nil) {
        [self received:obj];
    } else {
        NSString *path = @"images/get";
        NSString *params = [NSString stringWithFormat:@"entity=%@&entity_id=%@", type, type_id];
        [[[PostRequest alloc] init] exec:path params:params delegate:self callback:@selector(received:) type:@"image"];
    }
}

- (void)received:(UIImage *)response {
    if (cache[key] == nil) {
        cache[key] = response;
    }
    NSMethodSignature *methodSig = [[responseObject class] instanceMethodSignatureForSelector:responseCallback];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
    [invocation setSelector:responseCallback];
    [invocation setArgument:&response atIndex:2];
    [invocation setTarget:responseObject];
    [invocation retainArguments];
    [invocation invoke];
}

@end

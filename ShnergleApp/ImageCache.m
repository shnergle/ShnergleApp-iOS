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
        cache = [[NSCache alloc] init];
    }
    return self;
}

- (void)get:(NSString *)type identifier:(NSString *)type_id delegate:(id)object callback:(SEL)cb {
    responseObject = object;
    responseCallback = cb;
    key = [NSString stringWithFormat:@"%@/%@", type, type_id];
    if ([cache objectForKey:key] != NULL) {
        [self received:[cache objectForKey:key]];
    } else {
        NSString *path = @"images/get";
        NSString *params = [NSString stringWithFormat:@"entity=%@&entity_id=%@", type, type_id];
        [[[PostRequest alloc] init] exec:path params:params delegate:self callback:@selector(received:) type:@"image"];
    }
}

- (void)get:(NSString *)type identifier:(NSString *)type_id delegate:(id)object callback:(SEL)cb item:(CrowdItem *)tItem {
    item = tItem;
    [self get:type identifier:type_id delegate:object callback:cb];
}

- (void)received:(UIImage *)response {
    if ([cache objectForKey:key] == NULL) {
        [cache setObject:response forKey:key];
    }
    NSMethodSignature *methodSig = [[responseObject class] instanceMethodSignatureForSelector:responseCallback];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
    [invocation setSelector:responseCallback];
    [invocation setArgument:&response atIndex:2];
    if (item) [invocation setArgument:&item atIndex:3];
    [invocation setTarget:responseObject];
    [invocation retainArguments];
    [invocation invoke];
}

@end

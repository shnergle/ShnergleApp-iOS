//
//  ImageCache.m
//  ShnergleApp
//
//  Created by Adam Hani Schakaki on 02/06/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "ImageCache.h"
#import "PostRequest.h"

static NSCache *cache;

@implementation ImageCache

- (id)init {
    self = [super init];
    if (self != nil && cache == nil) {
        cache = [[NSCache alloc] init];
    }
    return self;
}

- (void)get:(NSString *)type identifier:(NSString *)type_id delegate:(id)object callback:(SEL)cb {
    responseObject = object;
    responseCallback = cb;
    key = [NSString stringWithFormat:@"%@/%@", type, type_id];
    if ([cache objectForKey:key] != nil) {
        [self received:[cache objectForKey:key]];
    } else {
        NSString *path = @"images/get";
        NSString *params = [NSString stringWithFormat:@"entity=%@&entity_id=%@", type, type_id];
        [[[PostRequest alloc] init] exec:path params:params delegate:self callback:@selector(received:) type:@"image"];
    }
}

+ (UIImage *)get:(NSString *)type identifier:(NSString *)type_id {
    NSString *key = [NSString stringWithFormat:@"%@/%@", type, type_id];
    return (UIImage *)[cache objectForKey:key];
}

+ (void)set:(NSString *)type identifier:(NSString *)type_id image:(UIImage *)image {
    NSString *key = [NSString stringWithFormat:@"%@/%@", type, type_id];
    [cache setObject:image forKey:key];
}

- (void)get:(NSString *)type identifier:(NSString *)type_id delegate:(id)object callback:(SEL)cb indexPath:(NSIndexPath *)index {
    indexPath = index;
    [self get:type identifier:type_id delegate:object callback:cb];
}

- (void)received:(UIImage *)response {
    if ([cache objectForKey:key] == nil && response != nil) {
        [cache setObject:response forKey:key];
    }
    NSMethodSignature *methodSig = [[responseObject class] instanceMethodSignatureForSelector:responseCallback];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
    [invocation setSelector:responseCallback];
    [invocation setArgument:&response atIndex:2];
    if (indexPath) [invocation setArgument:&indexPath atIndex:3];
    [invocation setTarget:responseObject];
    [invocation retainArguments];
    [invocation invoke];
}

@end

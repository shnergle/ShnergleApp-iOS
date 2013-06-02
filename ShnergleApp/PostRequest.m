//
//  PostRequest.m
//  ShnergleApp
//
//  Created by Adam Hani Schakaki on 01/06/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "PostRequest.h"
#import "AppDelegate.h"

@implementation PostRequest

- (void)exec:(NSString *)path params:(NSString *)params delegate:(id)object callback:(SEL)cb {
    [self exec:path params:params delegate:object callback:cb type:@"string"];
}

- (void)exec:(NSString *)path params:(NSString *)params delegate:(id)object callback:(SEL)cb type:(NSString *)type {
    NSString *urlString = [NSString stringWithFormat:@"http://shnergle-api.azurewebsites.net/%@", path];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSString *paramsString = [NSString stringWithFormat:@"app_secret=%@&%@", appDelegate.appSecret, params];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSMutableURLRequest *urlRequest=[NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[paramsString dataUsingEncoding:NSISOLatin1StringEncoding]];
    response = [[NSMutableData alloc] init];
    responseObject = object;
    responseCallback = cb;
    responseType = type;
    if (![[NSURLConnection alloc] initWithRequest:urlRequest delegate:self])
        NSLog(@"POST failed!");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [response appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    id responseArg;
    if ([responseType isEqual: @"image"])
        responseArg = [UIImage imageWithData:response];
    else
        responseArg = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    NSMethodSignature *methodSig = [[responseObject class] instanceMethodSignatureForSelector:responseCallback];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
    [invocation setSelector:responseCallback];
    [invocation setArgument:&responseArg atIndex:2];
    [invocation setTarget:responseObject];
    [invocation retainArguments];
    [invocation invoke];
}

@end

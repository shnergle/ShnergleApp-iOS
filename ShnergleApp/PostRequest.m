//
//  PostRequest.m
//  ShnergleApp
//
//  Created by Adam Hani Schakaki on 01/06/2013.
//  Copyright (c) 2013 Shnergle. All rights reserved.
//

#import "PostRequest.h"
#import "AppDelegate.h"
#import <SBJson/SBJson.h>

@implementation PostRequest

- (BOOL)exec:(NSString *)path params:(NSString *)params delegate:(id)object callback:(SEL)cb {
    return [self exec:path params:params delegate:object callback:cb type:@"json"];
}

- (BOOL)exec:(NSString *)path params:(NSString *)params delegate:(id)object callback:(SEL)cb type:(NSString *)type {
    NSString *urlString = [NSString stringWithFormat:@"http://shnergle-api.azurewebsites.net/v1/%@", path];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSString *paramsString = [NSString stringWithFormat:@"app_secret=%@&%@", appDelegate.appSecret, params];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[paramsString dataUsingEncoding:NSISOLatin1StringEncoding]];
    response = [[NSMutableData alloc] init];
    responseObject = object;
    responseCallback = cb;
    responseType = type;
    return !![[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
}

- (BOOL)exec:(NSString *)path params:(NSString *)params delegate:(id)object callback:(SEL)cb item:(CrowdItem *)tItem {
    item = tItem;
    return [self exec:path params:params delegate:object callback:cb];
}

- (BOOL)exec:(NSString *)path params:(NSString *)params delegate:(id)object callback:(SEL)cb type:(NSString *)type item:(CrowdItem *)tItem {
    item = tItem;
    return [self exec:path params:params delegate:object callback:cb type:type];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [response appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    id responseArg;
    if ([responseType isEqual:@"image"]) responseArg = [UIImage imageWithData:response];
    else if ([responseType isEqual:@"string"]) responseArg = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    else {
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSString *string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        id jsonObjects = [jsonParser objectWithString:string];
        responseArg = jsonObjects;
    }
    NSLog(@"\n\n\n\n%@\n\n\n\n",responseArg);
    NSMethodSignature *methodSig = [[responseObject class] instanceMethodSignatureForSelector:responseCallback];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
    [invocation setSelector:responseCallback];
    [invocation setArgument:&responseArg atIndex:2];
    if (item) [invocation setArgument:&item atIndex:3];
    [invocation setTarget:responseObject];
    [invocation retainArguments];
    [invocation invoke];
}

@end

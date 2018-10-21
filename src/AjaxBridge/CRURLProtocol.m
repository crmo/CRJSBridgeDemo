//
//  CRURLProtocol.m
//  CRJsBridgeDemo
//
//  Created by CRMO on 2018/10/19.
//  Copyright © 2018 crmo. All rights reserved.
//

#import "CRURLProtocol.h"

// 自定义协议，拦截WebView的所有请求
@implementation CRURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    return YES;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

- (void)startLoading {
    NSURL *url = [[self request] URL];
    // 1. 拦截“http://__jsbridge__”请求
    if ([url.host isEqualToString:@"__jsbridge__"]) {
        // 2. 从HTTPBody中取出调用参数
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:self.request.HTTPBody options:NSJSONReadingAllowFragments error:nil];
        NSString *action = dic[@"action"];
        NSString *data = dic[@"data"];
        NSData *responseData;
        
        // 3. 根据action转发到不同方法处理，param携带参数
        if ([action isEqualToString:@"alertMessage"]) {
            responseData = [data dataUsingEncoding:NSUTF8StringEncoding];
        } else {
            responseData = [@"Unknown action" dataUsingEncoding:NSUTF8StringEncoding];
        }
        
        // 4. 处理完成，将结果返回给js
        [self sendResponseWithResponseCode:200 data:responseData mimeType:@"text/html"];
    } else {
        NSData *data = [NSData dataWithContentsOfURL:url];
        [self sendResponseWithResponseCode:200 data:data mimeType:@"text/html"];
    }
}

- (void)stopLoading {
}

- (void)sendResponseWithResponseCode:(NSInteger)statusCode data:(NSData*)data mimeType:(NSString*)mimeType {
    NSHTTPURLResponse* response = [[NSHTTPURLResponse alloc] initWithURL:[[self request] URL] statusCode:statusCode HTTPVersion:@"HTTP/1.1" headerFields:@{@"Content-Type" : mimeType}];
    
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    if (data != nil) {
        [[self client] URLProtocol:self didLoadData:data];
    }
    [[self client] URLProtocolDidFinishLoading:self];
}


@end

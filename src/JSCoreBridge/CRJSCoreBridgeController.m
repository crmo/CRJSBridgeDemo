//
//  CRJsCoreBridgeController.m
//  CRJsBridgeDemo
//
//  Created by CRMO on 2018/10/19.
//  Copyright © 2018 crmo. All rights reserved.
//

#import "CRJSCoreBridgeController.h"
#import <JavaScriptCore/JavaScriptCore.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
#pragma clang diagnostic ignored "-Wdeprecated-implementations"

@interface CRJSCoreBridgeController () <UIWebViewDelegate>
@property (strong, nonatomic) UIWebView *webView;
@end

@implementation CRJSCoreBridgeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    // 注入JSBridge代码
    [self injectJSBridge];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"JSCoreExample" ofType:@"html"] ]];
    [_webView loadRequest:request];
}

/**
 JSCore方案的核心代码
 注入JSBridge代码
 */
- (void)injectJSBridge {
    // 获取JSContext
    JSContext *context = [_webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    // 给JS注入方法callNative
    context[@"callNative"] = ^(JSValue *action, JSValue *data) {
        NSString *actionStr = [action toString];
        NSString *dataStr = [data toString];
        if ([actionStr isEqualToString:@"alertMessage"]) {
            return dataStr;
        } else {
            return @"Unkown action";
        }
    };
}

#pragma mark-
#pragma mark UIWebViewDelegate

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"zl---[%s]", __FUNCTION__);
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"zl---[%s]", __FUNCTION__);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
}

#pragma clang diagnostic pop

@end

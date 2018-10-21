//
//  CRAjaxBridgeController.m
//  CRJsBridgeDemo
//
//  Created by CRMO on 2018/10/19.
//  Copyright © 2018 crmo. All rights reserved.
//

#import "CRAjaxBridgeController.h"
#import "CRURLProtocol.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
#pragma clang diagnostic ignored "-Wdeprecated-implementations" 

@interface CRAjaxBridgeController ()

@property (strong, nonatomic) UIWebView *webView;

@end

@implementation CRAjaxBridgeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    // 关键代码：注册自定义NSURLProtocol，拦截网络请求
    [NSURLProtocol registerClass:[CRURLProtocol class]];
    [self.view addSubview:_webView];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"AjaxExample" ofType:@"html"] ]];
    [_webView loadRequest:request];
}

#pragma clang diagnostic pop

@end

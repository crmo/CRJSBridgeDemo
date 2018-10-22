//
//  CRIframeBridgeController.m
//  CRJsBridgeDemo
//
//  Created by CRMO on 2018/10/19.
//  Copyright © 2018 crmo. All rights reserved.
//

#import "CRIframeBridgeController.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
#pragma clang diagnostic ignored "-Wdeprecated-implementations"

@interface CRIframeBridgeController ()<UIWebViewDelegate>
@property (strong, nonatomic) UIWebView *webView;
@end

@implementation CRIframeBridgeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"IframeExample" ofType:@"html"] ]];
    [_webView loadRequest:request];
}

#pragma mark-
#pragma mark UIWebViewDelegate

// 拦截JS调用原生核心方法
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *url = request.URL;
    
    // 判断url是否是JSBridge调用
    if ([url.host isEqualToString:@"__jsbridge__"]) {
        // 获取调用参数，demo的调用方式是：'https://__jsbridge__?action=action&data='
        // 参数直接放在query里面的，更好的方案是js暴露一个方法给原生，原生调用方法获取数据
        NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:YES];
        NSArray *queryItems = urlComponents.queryItems;
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        for (NSURLQueryItem *queryItem in queryItems) {
            NSString *key = queryItem.name;
            NSString *value = queryItem.value;
            [params setObject:value forKey:key];
        }
        NSString *action = params[@"action"];
        NSString *data = params[@"data"];
        
        if ([action isEqualToString:@"alertMessage"]) {
            // 调用原生方法，获取数据
            // js暴露方法`responseFromObjC`给原生，原生通过该方法回调
            // 在实际项目中，为了实现实现js并发原生方法，最好带一个callBackID，来区分不同的调用
            [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"responseFromObjC('%@')", data]];
        } else {
            [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"responseFromObjC('Unkown action')"]];
        }
        return NO;
    }
    
    return YES;
}

#pragma clang diagnostic pop

@end

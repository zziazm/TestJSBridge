//
//  ThirdViewController.m
//  TestJSBridge
//
//  Created by zm on 2020/8/14.
//  Copyright © 2020 zm. All rights reserved.
//

#import "ThirdViewController.h"
#import <WebKit/WebKit.h>
@interface ThirdViewController ()<WKUIDelegate, WKNavigationDelegate>
@property (weak, nonatomic) IBOutlet WKWebView *webView;

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"index2" ofType:@"html"];
    NSURL *baseURL = [[NSBundle mainBundle] bundleURL];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    [self.webView loadHTMLString:[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil] baseURL:baseURL];
    // Do any additional setup after loading the view.
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSURLRequest *request = [navigationAction request];
    NSString * scheme = request.URL.scheme;
    NSString * host = request.URL.host;
    NSString * query = request.URL.query;
    if ([scheme isEqualToString:@"test1"]) {
        NSString *methodName = host;
        if (query) {
            methodName = [methodName stringByAppendingString:@":"];
        }
        SEL sel = NSSelectorFromString(methodName);
        NSString *parameter = [[query componentsSeparatedByString:@"="] lastObject];
        [self performSelector:sel withObject:parameter];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
        
    }else if ([scheme isEqualToString:@"test2"]){//JS中的是Test2,在拦截到的url scheme全都被转化为小写。
        NSURL *url = request.URL;
        NSArray *params =[url.query componentsSeparatedByString:@"&"];
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
        for (NSString *paramStr in params) {
            NSArray *dicArray = [paramStr componentsSeparatedByString:@"="];
            if (dicArray.count > 1) {
                NSString *decodeValue = [dicArray[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [tempDic setObject:decodeValue forKey:dicArray[0]];
            }
        }
        
        
      UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"成功"
                                       message:[NSString stringWithFormat:@"这是OC原生的弹出窗"]
                                       preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
           handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        NSLog(@"tempDic:%@",tempDic);
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}
- (void)ocShowToast {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"成功"
                                   message:@"JS调用OC代码成功！"
                                   preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
       handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];

}

- (void)ocShowToastWithParameter:(NSString *)parama {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"成功"
                                   message:[NSString stringWithFormat:@"JS调用OC代码成功 - JS参数：%@",parama]
                                   preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
       handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

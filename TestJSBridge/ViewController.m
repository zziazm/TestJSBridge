//
//  ViewController.m
//  TestJSBridge
//
//  Created by zm on 2020/8/13.
//  Copyright © 2020 zm. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *htmlURL = [[NSBundle mainBundle] URLForResource:@"index.html" withExtension:nil];
    NSURLRequest *request = [NSURLRequest requestWithURL:htmlURL];
    [self.webView loadRequest:request];

    // Do any additional setup after loading the view.
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *scheme = request.URL.scheme;
    NSString *host = request.URL.host;
    NSString *query = request.URL.query;
    if ([scheme isEqualToString:@"test1"]) {
        NSString *methodName = host;
        if (query) {
            methodName = [methodName stringByAppendingString:@":"];
        }
        SEL sel = NSSelectorFromString(methodName);
        NSString *parameter = [[query componentsSeparatedByString:@"="] lastObject];
        [self performSelector:sel withObject:parameter];
        return NO;
    }else if ([scheme isEqualToString:@"test2"]){//JS中的是Test2,在拦截到的url scheme全都被转化为小写。
        NSURL *url = request.URL;
        NSArray *params =[url.query componentsSeparatedByString:@"&"];
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
        for (NSString *paramStr in params) {
            NSArray *dicArray = [paramStr componentsSeparatedByString:@"="];
            if (dicArray.count > 1) {
                NSString *decodeValue = [dicArray[1] stringByRemovingPercentEncoding];
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
        return NO;
    }
    return YES;
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
@end

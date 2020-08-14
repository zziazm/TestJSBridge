//
//  ForViewController.m
//  TestJSBridge
//
//  Created by zm on 2020/8/14.
//  Copyright © 2020 zm. All rights reserved.
//

#import "ForViewController.h"
#import <WebKit/WebKit.h>
@interface ForViewController ()<WKNavigationDelegate,WKUIDelegate, WKScriptMessageHandler>
@property (weak, nonatomic) IBOutlet WKWebView *webView;

@end

@implementation ForViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"index3" ofType:@"html"];
    NSURL *baseURL = [[NSBundle mainBundle] bundleURL];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    [self.webView loadHTMLString:[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil] baseURL:baseURL];
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"shareTitle"];
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"shareNothing"];

    // Do any additional setup after loading the view.
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSString *name = message.name;
    id body = message.body;
    NSLog(@"%@", message.name);
    NSLog(@"%@", message.body);
    
    if ([name isEqualToString:@"shareTitle"]) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"成功"
                                       message:@"JS调用OC代码成功！"
                                       preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
           handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    if ([name isEqualToString:@"shareNothing"]) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"成功"
                                       message:@"JS调用OC代码成功！"
                                       preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
           handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
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

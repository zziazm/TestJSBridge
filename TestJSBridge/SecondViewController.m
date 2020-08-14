//
//  SecondViewController.m
//  TestJSBridge
//
//  Created by zm on 2020/8/13.
//  Copyright © 2020 zm. All rights reserved.
//

#import "SecondViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@protocol TestJSExport<JSExport>
JSExportAs
(showAlert,
 - (void)showAlertWithParameters:(NSString *)parameterone parametertwo:(NSString *)parametertwo
 );
@end


@interface SecondViewController ()<TestJSExport>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *htmlURL = [[NSBundle mainBundle] URLForResource:@"index1.html" withExtension:nil];
    NSURLRequest *request = [NSURLRequest requestWithURL:htmlURL];
    [self.webView loadRequest:request];

    // Do any additional setup after loading the view.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //往js里注入block的方式来调用oc的block
    context[@"showToastWithparams"] = ^() {
        //NSLog(@"当前线程 - %@",[NSThread currentThread]);
        //注意，这时候是在子线程中的，要更新UI的话要回到主线程中
        NSArray *params = [JSContext currentArguments];
        for (JSValue *Param in params) {
            NSLog(@"%@", Param); // 打印结果就是JS传递过来的参数
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"成功"
                                           message:@"js调用oc原生代码成功!"
                                           preferredStyle:UIAlertControllerStyleAlert];
             
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
               handler:^(UIAlertAction * action) {}];
             
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        });
    };
    
    
    //使用JSExport协议进行js调用oc的方法
    context[@"JSObjective"] = self;

}


#pragma mark -- TestJSExport协议
- (void)showAlertWithParameters:(NSString *)parameterone parametertwo:(NSString *)parametertwo {
    NSLog(@"当前线程 - %@",[NSThread currentThread]);// 子线程
    //NSLog(@"JS和OC交互 - %@ -- %@",parameterone,parametertwo);
   //注意，这个代理方法也是在子线程中的
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"成功"
                                       message:[NSString stringWithFormat:@"js调用oc原生代码成功! - JS参数:%@,%@",parameterone,parametertwo]
                                       preferredStyle:UIAlertControllerStyleAlert];
         
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
           handler:^(UIAlertAction * action) {}];
         
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    });
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

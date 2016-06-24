//
//  SaveImageViewController.m
//  WebViewSaveImage-01
//
//  Created by long on 6/24/16.
//  Copyright © 2016 long. All rights reserved.
//

#import "SaveImageViewController.h"
#import "NSObject+Extension.h"

@interface SaveImageViewController ()<UIWebViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *webView;
@end


@implementation SaveImageViewController



#pragma mark -------------------
#pragma mark - CycLife

- (void)viewDidLoad{
    [super viewDidLoad];
    self.webView.delegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://image.baidu.com/wisebrowse/index?tag1=%E7%BE%8E%E5%A5%B3&tag2=%E5%85%A8%E9%83%A8&tag3=&pn=0&rn=10&from=index&fmpage=index&pos=magic#/home"]]];
}

#pragma mark --------------------
#pragma mark - Settings, Gettings

#pragma mark --------------------
#pragma mark - Events

#pragma mark -------------------
#pragma mark - Methods
- (void)saveImage:(NSString *)imageURL{
    NSLog(@"获取到图片地址:%@",imageURL);
}

- (void)injectJS:(UIWebView *)webView{
    // js 方法遍历图片点击事件 返回图片个数
    static NSString *const jsGetImages =
            @"function getImages(){\
            var objs = document.getElementsByTagName(\"img\");\
            for(var i=0;i<objs.length;i++){\
            objs[i].onclick=function(){\
            document.location.href=\"jscallbackoc://saveImage_*\"+this.src;\
            };\
            };\
            return objs.length;\
            };";
    [webView stringByEvaluatingJavaScriptFromString:jsGetImages]; // 注入js方法
    
    //注入自定义的js方法后别忘了调用 否则不会生效
    [webView stringByEvaluatingJavaScriptFromString:@"getImages()"]; // 调用js方法
    
    // 禁用用户选择
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    
    // 禁用长按弹框
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
}

- (void)performJSMethodWithURL:(NSString *)url protocolName:(NSString *)name performViewController:(UIViewController *)viewController{
    /*
     跳转url ：        jscallbackoc://sendMessage_number2_number3_*100$100$99
     protocolName：   jscallbackoc://
     方法名：          sendMessage:number2:number3
     参数：            100，100，99
     
     方法名和参数组合为oc的方法为：- (void)sendMessage:(NSString *)number number2:(NSString *)number2 number3:(NSString *)number3
     */
    
    // 获得协议后面的路径为： sendMessage_number2_*200$300
    NSString *path = [url substringFromIndex:name.length];
    
    
    // 利用“*”切割路径，“*”前面是方法名，后面是参数
    NSArray *subpaths = [path componentsSeparatedByString:@"*"];
    
    // 方法名 methodName == sendMessage:number2:
    // 下面的方法是把"_"替换为"?', js返回的url里面把“:”直接省略了，只能在js里面使用“_”来表示，然后在oc里面再替换回“:”
    NSString *methodName =[[subpaths firstObject ] stringByReplacingOccurrencesOfString:@"_" withString:@":"];
    
    // 参数  200$300，每个参数之间使用符号$链接（避免和url里面的其他字符混淆，因为一般url里面不会出现这个字符）
    NSArray *params = nil;
    if (subpaths.count == 2) {
        params = [[subpaths lastObject] componentsSeparatedByString:@"$"];
    }
    NSLog(@"方法名：%@-----参数：%@", methodName,params);
    // 调用NSObject类扩展方法，传递多个参数
    [self performSelector:NSSelectorFromString(methodName) withObjects:params];
}
#pragma mark --------------------
#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    //点击web页面的图片调用如下代码
    NSString *url = [[request URL] absoluteString];
    NSString *protocolName = @"jscallbackoc://";
    if ([url hasPrefix:protocolName]) {
        [self performJSMethodWithURL:url protocolName:protocolName performViewController:self ];
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self injectJS:webView];
}
#pragma mark ------------------
#pragma mark - KyoRefreshControlDelegate

#pragma mark --------------------
#pragma mark - NSNotification

#pragma mark --------------------
#pragma mark - KVO/KVC
@end

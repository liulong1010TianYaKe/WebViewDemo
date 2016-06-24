//
//  ViewController.m
//  WebViewSaveImage-01
//
//  Created by long on 6/23/16.
//  Copyright © 2016 long. All rights reserved.
//

#import "ViewController.h"

#define MTestURLSTRING  @"http://image.baidu.com/wisebrowse/index?tag1=%E7%BE%8E%E5%A5%B3&tag2=%E5%85%A8%E9%83%A8&tag3=&pn=0&rn=10&from=index&fmpage=index&pos=magic#/home"
//#define MTestURLSTRING  @"http://img01.taopic.com/141128/240418-14112Q04Q824.jpg"
//#define MTestURLSTRING  @"http://www.huize.com/about/contact.html"
//#define MTestURLSTRING  @"http://www.baidu.com"
@interface ViewController ()<UIWebViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.webView.delegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:MTestURLSTRING]]];
//    self.webView.backgroundColor = [UIColor clearColor];
//    self.webView.opaque = NO;
//    self.webView.scrollView.bounces = NO;
    
//    self.webView.scalesPageToFit = YES; //自动对页面进行缩放以适应屏幕
      //自动检测网页上的数据类型 电话号码,网页地址，单击可以拨打
//    self.webView.dataDetectorTypes = UIDataDetectorTypePhoneNumber|UIDataDetectorTypeLink;
    // 是否网页内容下载完毕后才开始渲染web视同  默认NO
//    self.webView.suppressesIncrementalRendering = YES;
    // 是否在web页面响应用户输入弹出键盘  默认YES
//    self.webView.keyboardDisplayRequiresUserAction = NO;
    // 这个值决定了用内嵌HTML5播放视频还是用本地的全屏控制。
    //为了内嵌视频播放，不仅仅需要在这个页面上设置这个属性，
   // 还必须的是在HTML中的video元素必须包含webkit-playsinline属性。默认使NO
//    self.webView.allowsInlineMediaPlayback =  YES;
    ///在iPhone和iPad上默认使YES。这个值决定了HTML5视频可以自动播放还是需要用户去启动播放
//    self.webView.mediaPlaybackRequiresUserAction = NO;
    self.longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
    self.longPressGesture.delegate = self;
    [self.webView addGestureRecognizer:self.longPressGesture];
}


- (void)longPressed:(UILongPressGestureRecognizer *)reconginzer{
    NSLog(@"state === %ld",(long)reconginzer.state);
    // 只在长按手势的时候才去获取图片的url
    if (reconginzer.state != UIGestureRecognizerStateBegan) {
        return;
    }
    
    CGPoint  touchPoint = [reconginzer locationInView:self.webView];
    NSString *js = [NSString stringWithFormat:@"document.elementFromPoint(%f,%f).src",touchPoint.x,touchPoint.y];
    NSLog(@"%@",js);
    NSString *urlToSave = [self.webView stringByEvaluatingJavaScriptFromString:js];
    if (urlToSave.length == 0) {
        return;
    }
    
    NSLog(@"获取图片的地址:%@",urlToSave);
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

/**
 *
 UIWebViewNavigationTypeLinkClicked，用户触击了一个链接。
 UIWebViewNavigationTypeFormSubmitted，用户提交了一个表单。
 UIWebViewNavigationTypeBackForward，用户触击前进或返回按钮。
 UIWebViewNavigationTypeReload，用户触击重新加载的按钮。
 UIWebViewNavigationTypeFormResubmitted，用户重复提交表单
 UIWebViewNavigationTypeOther，发生其它行为
 */
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
//     NSLog(@"============ shouldStartLoadWithRequest %ld ============",(long)navigationType);
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
//     NSLog(@"============ webViewDidFinishLoad ============");
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{

//    NSLog(@"============ webViewDidFinishLoad ============");
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{
    NSLog(@"============ didFailLoadWithError %@ ============",error);
}
@end

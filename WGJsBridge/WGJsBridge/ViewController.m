//
//  ViewController.m
//  WGJsBridge
//
//  Created by 王刚 on 2017/12/1.
//  Copyright © 2017年 Gary Wong. All rights reserved.
//

#import "ViewController.h"
#import "UIWebView+WGJsBridge.h"

@interface ViewController () <UIWebViewDelegate>

@property (nonatomic,strong)UIWebView *localWebView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

- (void)setUI{
    UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 50)];
    web.delegate = self;
    //加载本地html网页
    NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSString *htmlContent = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [web loadHTMLString:htmlContent baseURL:nil];
    //显示网页在页面上
    [self.view addSubview:web];
    
    self.localWebView = web;
    
    //原生的button
    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
    b.frame = CGRectMake(0, self.view.frame.size.height-50, self.view.frame.size.width/2, 50);
    b.backgroundColor = [UIColor redColor];
    [b setTitle:@"调用网页js中的方法" forState:UIControlStateNormal];
    b.titleLabel.font = [UIFont systemFontOfSize:12];
    [b addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b];
    
    
    UIButton *b1 = [UIButton buttonWithType:UIButtonTypeCustom];
    b1.frame = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height-50, self.view.frame.size.width/2, 50);
    b1.backgroundColor = [UIColor greenColor];
    [b1 setTitle:@"调用网页js中的方法 带参数" forState:UIControlStateNormal];
    b1.titleLabel.font = [UIFont systemFontOfSize:12];
    [b1 addTarget:self action:@selector(buttonClickWithParam) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b1];
}

/**
 *  调用网页js中的脚本方法
 */
- (void)buttonClick{
    NSString *jsFunctionStr = @"handleJs";
    [_localWebView handleJsFunctionWithFunctionName:jsFunctionStr withParamsArray:nil];
}

/**
 *  调用网页js中的脚本方法,并且传参
 */
- (void)buttonClickWithParam{
    NSString *jsFunctionStr = @"handleJs";
    NSArray *arr = @[@"我想传一个参数",@"我想传第二个参数"];
    [_localWebView handleJsFunctionWithFunctionName:jsFunctionStr withParamsArray:arr];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"网页加载完毕后才能使用js调用oc方法");
    
    [_localWebView handleOcFunctionWithOcFunctionName:@"doOcFunction" andOcFunctionBlock:^(id object) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray *arr = (NSArray *)object;
            for (id obj in arr) {
                NSLog(@"参数为:%@",obj);
            }
            [self doOcFunction];
        });
    }];
    
    [_localWebView handleOcFunctionWithOcFunctionName:@"doOcFunctionWithParams" andOcFunctionBlock:^(id object) {
        NSArray *arr = (NSArray *)object;
        [self doOcFunctionWithParams:arr];
    }];
}

/**
 *  js要调用的oc原生方法 非主线程方法,要操作UI必须获取主线程
 */
- (void)doOcFunction{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"" message:@"js调用了oc方法" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [a show];
    });
}

/**
 *  js要调用的oc原生方法 非主线程方法,要操作UI必须获取主线程
 *
 *  @param arr 需要传入的参数
 */
- (void)doOcFunctionWithParams:(NSArray *)arr{
    int i = 0;
    for (id obj in arr) {
        NSLog(@"传入的参数总共有%lu个,当前为第%d个,参数值为:%@",(unsigned long)arr.count,i,obj);
        i ++;
    }
}



@end

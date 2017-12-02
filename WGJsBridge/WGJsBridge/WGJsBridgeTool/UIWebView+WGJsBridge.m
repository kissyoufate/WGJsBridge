//
//  UIWebView+WGJsBridge.m
//  WGJsBridge
//
//  Created by 王刚 on 2017/12/1.
//  Copyright © 2017年 Gary Wong. All rights reserved.
//

#import "UIWebView+WGJsBridge.h"

static NSString *DOCUMENTSTRING = @"documentView.webView.mainFrame.javaScriptContext";

@implementation UIWebView (WGJsBridge)

- (void)handleJsFunctionWithFunctionName:(NSString *)functionName withParamsArray:(NSArray *)paramsArr{
    if (!functionName || [functionName isEqualToString:@""]) {
        NSLog(@"js方法名字不能为空");
        return;
    }
    
    if (paramsArr && paramsArr.count>0) {
        
        NSMutableString *mStr = [NSMutableString stringWithString:@""];
        
        for (int i=0; i<paramsArr.count; i++) {
            if (i == paramsArr.count - 1) {
                [mStr appendString:[NSString stringWithFormat:@"'%@'",paramsArr[i]]];
            }else{
                [mStr appendString:[NSString stringWithFormat:@"'%@',",paramsArr[i]]];
            }
        }
        functionName = [NSString stringWithFormat:@"%@(%@)",functionName,mStr];
    }else{
        functionName = [NSString stringWithFormat:@"%@()",functionName];
    }
    
    [self stringByEvaluatingJavaScriptFromString:functionName];
}

-(void)handleOcFunctionWithOcFunctionName:(NSString *)jsFunctionName andOcFunctionBlock:(functionHandle)functionHandle{
    if (!jsFunctionName || [jsFunctionName isEqualToString:@""]) {
        NSLog(@"没有接收到方法名字");
        return;
    }
    
    JSContext *context = [self valueForKeyPath:DOCUMENTSTRING];
    
    context[jsFunctionName] = ^() {
        NSArray *args = [JSContext currentArguments];
        if (args.count) {
            NSMutableArray *marr = [NSMutableArray array];
            for (JSValue *jsVal in args) {
                [marr addObject:jsVal.toString];
            }
            functionHandle(marr);
        }else{
            functionHandle(args);
        }
    };
}

@end

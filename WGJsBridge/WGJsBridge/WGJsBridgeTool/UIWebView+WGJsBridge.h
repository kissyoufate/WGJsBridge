//
//  UIWebView+WGJsBridge.h
//  WGJsBridge
//
//  Created by 王刚 on 2017/12/1.
//  Copyright © 2017年 Gary Wong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

typedef void(^functionHandle)(id object);

@interface UIWebView (WGJsBridge)

/**
 *  oc调用js的方法,支持传入0~n个参数
 *
 *  @param functionName js中的方法名字,不需要加();
 *  @param paramsArr    字符串数组
 */
- (void)handleJsFunctionWithFunctionName:(NSString *)functionName withParamsArray:(NSArray *)paramsArr;

/**
 *  js调用oc的方法 在UIWebView 的代理方法 - (void)webViewDidFinishLoad:(UIWebView *)webView 中调用此方法,否则无效 如果有参数会自动返回一个数组对象,请判断数组的长度然后自行遍历获取
 *
 *  @param jsFunctionName js中调用oc的方法,该方法需要在所调用的class实现,并且该方法名字必须在js与oc类中保持相同
 *  @param functionHandle 调用的实现方法回调,如果需要执行UI相关的操作,必须回到主线程再执行
 */
-(void)handleOcFunctionWithJsFunctionName:(NSString *)jsFunctionName andOcFunctionBlock:(functionHandle)functionHandle;

@end

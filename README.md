# WGJsBridge
一个js脚本语言与原生oc相互调用的工具类,采用分类的形势编写,轻量级无侵入性,回调进行,注释详尽,有bug请留言,适用于ios7.0以上的系统版本
傻瓜式调用,一句话相互调用题,拒绝长篇大论


How to use:

前提:
下载工程源码

将WGJsBridgeTool下的两个文件拖入工程

import "UIWebView+WGJsBridge.h"

原生object-c调用javascript方法

//1.不传入参数的调用

    [webview handleJsFunctionWithFunctionName:@"targetJsFunctionName" withParamsArray:nil];

//2.传入1~n个参数的调用

    [webview handleJsFunctionWithFunctionName:@"targetJsFunctionName" withParamsArray:@[param1,param2,param3,...]];

*注意事项

targetJsFunctionName 为js中需要调用的方法,不需要传入(),切记!

参数为数组的形势传入,在js方法中进行接收


jsvascript调用原生object-c方法

*前提 需要在网页完全加载完毕的代理方法中进行方法的调用

//1.不带参数的方法调用

    [webView handleOcFunctionWithOcFunctionName:@"targetOcFuntion" andOcFunctionBlock:^(id object) {
        //该方法为非主线程执行,如果需要在方法中操作UI则需要返回主线程!
        dispatch_async(dispatch_get_main_queue(), ^{
            //需要调用的oc方法
            [self targetOcFuntion];
        });
    }];
   
//2.1 带参数的方法调用

//2.2 targetOcFuntion只需要写oc方法的主名字,无需后面带参的部分

    [_localWebView handleOcFunctionWithOcFunctionName:@"targetOcFuntion" andOcFunctionBlock:^(id object) {
        //如果该js方法有参数传入,则会自动返回一个泛型数组,请自行遍历取出所需要的参数
        NSArray *arr = (NSArray *)object;
        [self targetOcFuntion:arr];
    }];
    



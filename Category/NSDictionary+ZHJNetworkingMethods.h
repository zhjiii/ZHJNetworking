//
//  NSDictionary+ZHJNetworkingMethods.h
//  patient-app
//
//  Created by zhuhongji on 2016/10/24.
//  Copyright © 2016年 zhuhongji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (ZHJNetworkingMethods)

/* 字符串前面是没有问号的，如果用于POST，那就不用加问号，如果用于GET，就要加个问号 */
- (NSString *)AIF_urlParamsStringSignature;

/* 转义参数 */
- (NSArray *)AIF_transformedUrlParamsArraySignature;

@end

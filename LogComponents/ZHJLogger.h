//
//  ZHJLogger.h
//  patient-app
//
//  Created by zhuhongji on 2016/10/24.
//  Copyright © 2016年 zhuhongji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHJService.h"
#import "ZHJURLResponse.h"

@interface ZHJLogger : NSObject

+ (instancetype)sharedInstance;

+ (void)logDebugInfoWithRequest:(NSURLRequest *)request apiName:(NSString *)apiName service:(ZHJService *)service requestParams:(id)requestParams httpMethod:(NSString *)httpMethod;

+ (void)logDebugInfoWithResponse:(NSHTTPURLResponse *)response resposeString:(NSString *)responseString request:(NSURLRequest *)request error:(NSError *)error;

+ (void)logDebugInfoWithCachedResponse:(ZHJURLResponse *)response methodName:(NSString *)methodName serviceIdentifier:(ZHJService *)service;


@end

//
//  ZHJURLResponse.h
//  patient-app
//
//  Created by zhuhongji on 2016/10/21.
//  Copyright © 2016年 zhuhongji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHJNetworkingConfiguration.h"

@interface ZHJURLResponse : NSObject

@property (nonatomic, assign, readonly) ZHJURLResponseStatus status;
@property (nonatomic, copy, readonly) id content;
@property (nonatomic, copy, readonly) NSData *responseData;
@property (nonatomic, assign, readonly) NSInteger requestId;
@property (nonatomic, strong, readonly) NSURLRequest *request;
@property (nonatomic, assign, readonly) BOOL isCache;
@property (nonatomic, copy) NSDictionary *requestParams;

- (instancetype)initWithRequestId:(NSNumber *)requestId request:(NSURLRequest *)request responseData:(NSData *)responseData error:(NSError *)error;

//读取缓存时用这个构造函数
- (instancetype)initWithData:(NSData *)data;

@end

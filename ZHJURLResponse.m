//
//  ZHJURLResponse.m
//  patient-app
//
//  Created by zhuhongji on 2016/10/21.
//  Copyright © 2016年 zhuhongji. All rights reserved.
//

#import "ZHJURLResponse.h"
#import "NSURLRequest+Properties.h"

@interface ZHJURLResponse ()

@property (nonatomic, assign, readwrite) ZHJURLResponseStatus status;
@property (nonatomic, copy, readwrite) id content;
@property (nonatomic, copy, readwrite) NSData *responseData;
@property (nonatomic, assign, readwrite) NSInteger requestId;
@property (nonatomic, strong, readwrite) NSURLRequest *request;
@property (nonatomic, assign, readwrite) BOOL isCache;

@end

@implementation ZHJURLResponse

#pragma mark - life cycle

- (instancetype)initWithRequestId:(NSNumber *)requestId request:(NSURLRequest *)request responseData:(NSData *)responseData error:(NSError *)error{
    self = [super init];
    if (self) {
        if (responseData) {
            self.content = [NSJSONSerialization JSONObjectWithData:responseData
                                                           options:NSJSONReadingMutableContainers
                                                             error:NULL];
        }else{
            self.content = nil;
        }
        self.status = [self responseStatusWithError:error];
        self.requestId = [requestId integerValue];
        self.responseData = responseData;
        self.request = request;
        self.requestParams = request.requestParams;
        self.isCache = NO;
    }
    return self;
}

- (instancetype)initWithData:(NSData *)data{
    self = [super init];
    if (self) {
        self.status = [self responseStatusWithError:nil];
        self.requestId = 0;
        self.request = nil;
        self.responseData = [data copy];
        self.content = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
        self.isCache = YES;
    }
    return self;
}

#pragma mark - private methods

- (ZHJURLResponseStatus)responseStatusWithError:(NSError *)error{
    if (error) {
        ZHJURLResponseStatus result = ZHJURLResponseStatusErrorNoNetwork;
        // 除了超时以外，所有错误都当成是无网络
        if (error.code == NSURLErrorTimedOut) {
            result = ZHJURLResponseStatusErrorTimeout;
        }
        return result;
    } else {
        return ZHJURLResponseStatusSuccess;
    }
}

@end

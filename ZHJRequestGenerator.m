//
//  ZHJRequestGenerator.m
//  patient-app
//
//  Created by zhuhongji on 2016/10/21.
//  Copyright © 2016年 zhuhongji. All rights reserved.
//

#import <AFNetworking/AFURLRequestSerialization.h>

#import "ZHJRequestGenerator.h"
#import "ZHJServiceFactory.h"
#import "ZHJLogger.h"
#import "NSURLRequest+Properties.h"

@interface ZHJRequestGenerator ()

@property (nonatomic, strong) AFHTTPRequestSerializer *httpRequestSerializer;

@end

@implementation ZHJRequestGenerator

#pragma mark - life cycle

+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    static ZHJRequestGenerator *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ZHJRequestGenerator alloc] init];
    });
    return sharedInstance;
}

#pragma mark - public methods

- (NSURLRequest *)generateGETRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName{
    
    NSString *urlString = [self generateURLStringWithServiceIdentifier:serviceIdentifier methodName:methodName];
    NSMutableURLRequest *request = [self.httpRequestSerializer requestWithMethod:@"GET" URLString:urlString parameters:requestParams error:NULL];
    request.requestParams = requestParams;
    [ZHJLogger logDebugInfoWithRequest:request apiName:methodName service:[self generateService:serviceIdentifier] requestParams:requestParams httpMethod:@"GET"];
    return request;
}

- (NSURLRequest *)generatePOSTRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName{
    
    NSString *urlString = [self generateURLStringWithServiceIdentifier:serviceIdentifier methodName:methodName];
    NSMutableURLRequest *request = [self.httpRequestSerializer requestWithMethod:@"POST" URLString:urlString parameters:requestParams error:NULL];
    request.requestParams = requestParams;
    [ZHJLogger logDebugInfoWithRequest:request apiName:methodName service:[self generateService:serviceIdentifier] requestParams:requestParams httpMethod:@"POST"];
    return request;
}

#pragma mark - private methods

- (NSString *)generateURLStringWithServiceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName{
    ZHJService *service = [self generateService:serviceIdentifier];
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@", service.apiBaseUrl, service.apiVersion, methodName];
    return urlString;
}

- (ZHJService *)generateService:(NSString *)serviceIdentifier{
    ZHJService *service = [[ZHJServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier];
    return service;
}

#pragma mark - get & set

- (AFHTTPRequestSerializer *)httpRequestSerializer{
    if (!_httpRequestSerializer) {
        _httpRequestSerializer = [AFHTTPRequestSerializer serializer];
        _httpRequestSerializer.timeoutInterval = 10;
        _httpRequestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    }
    return _httpRequestSerializer;
}

@end

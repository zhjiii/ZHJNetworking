//
//  ZHJAPIProxy.m
//  patient-app
//
//  Created by zhuhongji on 2016/10/21.
//  Copyright © 2016年 zhuhongji. All rights reserved.
//

#import "AFNetworking.h"
#import "ZHJAPIProxy.h"
#import "ZHJRequestGenerator.h"
#import "ZHJURLResponse.h"
#import "ZHJLogger.h"

@interface ZHJAPIProxy ()

@property (nonatomic, strong) NSMutableDictionary *dispatchTable;
@property (nonatomic, strong) AFURLSessionManager *sessionManager;
@property (nonatomic, strong) NSNumber *recordedRequestId;

@end

@implementation ZHJAPIProxy

#pragma mark - life cycle

+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    static ZHJAPIProxy *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ZHJAPIProxy alloc] init];
    });
    return sharedInstance;
}

#pragma mark - public methods

- (NSInteger)callGETWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName completionHandler:(void (^)(ZHJURLResponse *, NSError *))completionHandler{
    NSURLRequest *request = [[ZHJRequestGenerator sharedInstance] generateGETRequestWithServiceIdentifier:servieIdentifier requestParams:params methodName:methodName];
    NSNumber *requestId = [self callApiWithRequest:request completionHandler:completionHandler];
    return [requestId integerValue];
}

- (NSInteger)callPOSTWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName completionHandler:(void (^)(ZHJURLResponse *, NSError *))completionHandler{
    NSURLRequest *request = [[ZHJRequestGenerator sharedInstance] generatePOSTRequestWithServiceIdentifier:servieIdentifier requestParams:params methodName:methodName];
    NSNumber *requestId = [self callApiWithRequest:request completionHandler:completionHandler];
    return [requestId integerValue];
}

- (void)cancelRequestWithRequestID:(NSNumber *)requestID{
    NSURLSessionDataTask *urlSessionDataTask = self.dispatchTable[requestID];
    [urlSessionDataTask cancel];
    [self.dispatchTable removeObjectForKey:requestID];
}

- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList{
    for (NSNumber *requestId in requestIDList) {
        [self cancelRequestWithRequestID:requestId];
    }
}

#pragma mark - private methods

- (NSNumber *)callApiWithRequest:(NSURLRequest *)request completionHandler:(void (^)(ZHJURLResponse *, NSError *))completionHandler{
    NSNumber *requestId = [self generateRequestId];
    
    NSURLSessionDataTask *urlSessionDataTask = [self.sessionManager dataTaskWithRequest:request completionHandler:
                                                ^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                                    
                                                    if (!self.dispatchTable[requestId]) { //如果请求被取消，直接返回
                                                        return ;
                                                    }else {
                                                        [self.dispatchTable removeObjectForKey:requestId];
                                                    }
                                                    ZHJURLResponse *URLResponse = [[ZHJURLResponse alloc] initWithRequestId:requestId
                                                                                                                    request:request
                                                                                                               responseData:responseObject error:error];
                                                    
                                                    completionHandler?completionHandler(URLResponse,error):nil;
                                                    
                                                    [ZHJLogger logDebugInfoWithResponse:(NSHTTPURLResponse *)response
                                                                          resposeString:URLResponse.content
                                                                                request:request
                                                                                  error:NULL];
                                                    
                                                }];
    self.dispatchTable[requestId] = urlSessionDataTask;
    [urlSessionDataTask resume];
    return requestId;
}

- (NSNumber *)generateRequestId{
    if (!_recordedRequestId) {
        _recordedRequestId = @(1);
    } else {
        if ([_recordedRequestId integerValue] == NSIntegerMax) {
            _recordedRequestId = @(1);
        } else {
            _recordedRequestId = @([_recordedRequestId integerValue] + 1);
        }
    }
    return _recordedRequestId;
}

#pragma mark - getter & setter

- (AFURLSessionManager *)sessionManager{
    if (!_sessionManager) {
        _sessionManager = [[AFURLSessionManager alloc] init];
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return _sessionManager;
}

- (NSMutableDictionary *)dispatchTable{
    if (!_dispatchTable) {
        _dispatchTable = [[NSMutableDictionary alloc] init];
    }
    return _dispatchTable;
}

@end

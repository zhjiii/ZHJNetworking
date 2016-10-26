//
//  ZHJAPIBaseManager.m
//  patient-app
//
//  Created by zhuhongji on 2016/10/20.
//  Copyright © 2016年 zhuhongji. All rights reserved.
//

//AFNetworking
#import <AFNetworking/AFNetworkReachabilityManager.h>
#import "AFNetworkReachabilityManager.h"
#import "AFHTTPSessionManager.h"

//self
#import "ZHJAPIBaseManager.h"
#import "ZHJNetworking.h"
#import "ZHJURLResponse.h"
#import "ZHJServiceFactory.h"
#import "ZHJCache.h"
#import "ZHJLogger.h"
#import "AppMacro.h"

//tool
#import "MBProgressHUD.h"

#define ZHJCallAPI(REQUEST_METHOD,REQUEST_ID) \
{                                              \
    REQUEST_ID = [[ZHJAPIProxy sharedInstance] call##REQUEST_METHOD##WithParams:params serviceIdentifier:self.child.serviceType methodName:self.child.methodName completionHandler:^(ZHJURLResponse *response, NSError *error) {\
        [self removeRequestIdWithRequestID:response.requestId]; \
        if (!error) { \
            [self successedOnCallingAPI:response CompleteHandle:completeHandle];\
        }else{ \
            [self failedOnCallingAPI:nil errorType:ZHJAPIManagerErrorTypeNoNetWork CompleteHandle:completeHandle];\
        }\
    }];\
    [self.requestIdList addObject:@(REQUEST_ID)];\
}

@interface ZHJAPIBaseManager ()

@property (nonatomic, strong) NSMutableArray *requestIdList;
@property (nonatomic, readwrite) ZHJAPIManagerErrorType errorType;
@property (strong, nonatomic) ZHJCache *cache;

@end

@implementation ZHJAPIBaseManager

#pragma mark - lify cycle

- (instancetype)init{
    self = [super init];
    if (self) {
        if ([self conformsToProtocol:@protocol(ZHJAPIManager)]) {
            self.child = (id <ZHJAPIManager>)self;
        }
    }
    return self;
}

- (void)dealloc{
    [self cancelAllRequests];
    self.requestIdList = nil;
}

#pragma mark - public methods

- (void)cancelAllRequests{
    [[ZHJAPIProxy sharedInstance] cancelRequestWithRequestIDList:self.requestIdList];
    [self.requestIdList removeAllObjects];
}

- (void)cancelRequestWithRequestId:(NSInteger)requestID{
    [self removeRequestIdWithRequestID:requestID];
    [[ZHJAPIProxy sharedInstance] cancelRequestWithRequestID:@(requestID)];
}

- (NSInteger)loadDataCompleteHandle:(ZHJAPIManagerCompleteHandle)completeHandle{
    return [self loadDataWithParams:[self.paramSource paramsForApi:self] CompleteHandle:completeHandle];
}

#pragma mark - private mathods

- (void)removeRequestIdWithRequestID:(NSInteger)requestId{
    NSNumber *requestIDToRemove = nil;
    for (NSNumber *storedRequestId in self.requestIdList) {
        if ([storedRequestId integerValue] == requestId) {
            requestIDToRemove = storedRequestId;
        }
    }
    if (requestIDToRemove) {
        [self.requestIdList removeObject:requestIDToRemove];
    }
}

- (BOOL)hasCacheWithParams:(NSDictionary *)params CompleteHandle:(ZHJAPIManagerCompleteHandle)completeHandle{
    NSString *serviceIdentifier = self.child.serviceType;
    NSString *methodName = self.child.methodName;
    NSData *result = [self.cache fetchCachedDataWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:params];
    
    if (result == nil) {
        return NO;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        ZHJURLResponse *response = [[ZHJURLResponse alloc] initWithData:result];
        response.requestParams = params;
        [ZHJLogger logDebugInfoWithCachedResponse:response methodName:methodName serviceIdentifier:[[ZHJServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier]];
        [self successedOnCallingAPI:response CompleteHandle:completeHandle];
    });
    return YES;
}

#pragma mark - calling api

- (NSInteger)loadDataWithParams:(NSDictionary *)params
                 CompleteHandle:(ZHJAPIManagerCompleteHandle)completeHandle{
    NSInteger requestId = 0;
    if ([self.validator manager:self isCorrectWithParamsData:params]) {
        
        // 先检查一下是否有缓存
        if (([self outdateTimeSeconds] > 0) && [self hasCacheWithParams:params CompleteHandle:completeHandle]) {
            return 0;
        }
        
        if ([self isReachable]) {
            switch ([self.child requestType]) {
                case ZHJAPIManagerRequestTypeGet:{
                    ZHJCallAPI(GET,requestId);
                    break;
                }
                case ZHJAPIManagerRequestTypePost:{
                    ZHJCallAPI(POST,requestId);
                    break;
                }
                default:{
                    break;
                }
            }
        }else{
            [self failedOnCallingAPI:nil errorType:ZHJAPIManagerErrorTypeNoNetWork CompleteHandle:completeHandle];
        }
    }else{
        [self failedOnCallingAPI:nil errorType:ZHJAPIManagerErrorTypeParamsError CompleteHandle:completeHandle];
    }
    return requestId;
}

#pragma mark - api callback

- (void)successedOnCallingAPI:(ZHJURLResponse *)response CompleteHandle:(ZHJAPIManagerCompleteHandle)completeHandle{
    if ([self.validator manager:self isCorrectWithCallBackData:response.content]) {
        if (([self outdateTimeSeconds] > 0) && !response.isCache) {
            [self.cache saveCacheWithData:response.responseData serviceIdentifier:self.child.serviceType methodName:self.child.methodName requestParams:response.requestParams outdateTimeSeconds:[self outdateTimeSeconds]];
        }
        if (completeHandle){
            completeHandle(response.content, ZHJAPIManagerErrorTypeSuccess);
        }
    }else{
        [self failedOnCallingAPI:response errorType:ZHJAPIManagerErrorTypeNoContent CompleteHandle:completeHandle];
    }
}

- (void)failedOnCallingAPI:(ZHJURLResponse *)response errorType:(ZHJAPIManagerErrorType)errorType CompleteHandle:(ZHJAPIManagerCompleteHandle)completeHandle{
    if (completeHandle){
        completeHandle((response ? response.content: nil),errorType);
    }
}

#pragma mark - child method

- (NSString *)serviceType{
    return nil;
}

- (NSTimeInterval)outdateTimeSeconds{
    return 0;
}

#pragma mark - getter & setter

- (ZHJCache *)cache{
    if (!_cache) {
        _cache = [ZHJCache sharedInstance];
    }
    return _cache;
}

- (BOOL)isReachable{
    BOOL isReachability;
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusUnknown) {
        isReachability = YES;
    } else {
        isReachability = [[AFNetworkReachabilityManager sharedManager] isReachable];
    }
    if (!isReachability) {
        self.errorType = ZHJAPIManagerErrorTypeNoNetWork;
    }
    return isReachability;
}

- (NSMutableArray *)requestIdList{
    if (!_requestIdList) {
        _requestIdList = [[NSMutableArray alloc] init];
    }
    return _requestIdList;
}

- (BOOL)isLoading{
    return [self.requestIdList count] > 0;
}

@end

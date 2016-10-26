//
//  ZHJAPIBaseManager.h
//  patient-app
//
//  Created by zhuhongji on 2016/10/20.
//  Copyright © 2016年 zhuhongji. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZHJAPIBaseManager;
/*
 返回数据不正确的几种类型。
 你不应该在回调数据验证函数里面设置这些值，事实上，在任何派生的子类里面你都不应该自己设置manager的这个状态，baseManager已经帮你搞定了。
 强行修改manager的这个状态有可能会造成程序流程的改变，容易造成混乱。
 */
typedef NS_ENUM (NSUInteger, ZHJAPIManagerErrorType){
    ZHJAPIManagerErrorTypeDefault,       //没有产生过API请求，这个是manager的默认状态。
    ZHJAPIManagerErrorTypeSuccess,       //API请求成功且返回数据正确，此时manager的数据是可以直接拿来使用的。
    ZHJAPIManagerErrorTypeNoContent,     //API请求成功但返回数据不正确。如果回调数据验证函数返回值为NO，manager的状态就会是这个。
    ZHJAPIManagerErrorTypeParamsError,   //参数错误，此时manager不会调用API，因为参数验证是在调用API之前做的。
    ZHJAPIManagerErrorTypeTimeout,       //请求超时。RTApiProxy设置的是20秒超时，具体超时时间的设置请自己去看RTApiProxy的相关代码。
    ZHJAPIManagerErrorTypeNoNetWork      //网络不通。在调用API之前会判断一下当前网络是否通畅，这个也是在调用API之前验证的，和上面超时的状态是有区别的。
};

typedef NS_ENUM (NSUInteger, ZHJAPIManagerRequestType){
    ZHJAPIManagerRequestTypeGet,
    ZHJAPIManagerRequestTypePost,
    ZHJAPIManagerRequestTypeRestGet,    //不清楚是什么type
    ZHJAPIManagerRequestTypeRestPost    //同上
};

typedef void (^ZHJAPIManagerCompleteHandle)(id responseData, ZHJAPIManagerErrorType errorType);

/*************************************************************************************************/
/*                                ZHJAPIManagerParamSourceDelegate                               */
/*************************************************************************************************/
//让manager能够获取调用API所需要的数据
@protocol ZHJAPIManagerParamSourceDelegate <NSObject>

@required
- (NSDictionary *)paramsForApi:(ZHJAPIBaseManager *)manager;

@end

/*************************************************************************************************/
/*                                     ZHJAPIManagerValidator                                    */
/*************************************************************************************************/
//验证器，用于验证API的返回数据或调用API的参数是否正确,一般由APIManager代理
@protocol ZHJAPIManagerValidator <NSObject>

@required
//对返回的数据进行验证
- (BOOL)manager:(ZHJAPIBaseManager *)manager isCorrectWithCallBackData:(NSDictionary *)data;
//对调用api时需要的参数进行验证
- (BOOL)manager:(ZHJAPIBaseManager *)manager isCorrectWithParamsData:(NSDictionary *)data;

@end

/*************************************************************************************************/
/*                                         ZHJAPIManager                                         */
/*************************************************************************************************/
//ZHJAPIBaseManager的派生类必须符合这些protocal
@protocol ZHJAPIManager <NSObject>

@required
- (NSString *)methodName; // 方法名
- (ZHJAPIManagerRequestType)requestType; // 请求类型

@optional
- (NSString *)serviceType; // 服务器名
- (void)cleanData;
- (NSDictionary *)reformParams:(NSDictionary *)params;
- (NSTimeInterval)outdateTimeSeconds; //设置缓存时间，默认为0

@end

@interface ZHJAPIBaseManager : NSObject

@property (nonatomic, weak) id<ZHJAPIManagerParamSourceDelegate> paramSource;
@property (nonatomic, weak) id<ZHJAPIManagerValidator> validator;
@property (nonatomic, weak) NSObject<ZHJAPIManager> *child;

@property (assign, nonatomic, readonly) BOOL isReachable;
@property (assign, nonatomic, readonly) BOOL isLoading;

//加载数据
//返回数据为requestId
- (NSInteger)loadDataCompleteHandle:(ZHJAPIManagerCompleteHandle)completeHandle;
- (NSInteger)loadDataWithParams:(NSDictionary *)params CompleteHandle:(ZHJAPIManagerCompleteHandle)completeHandle;

//取消所有网络请求,一般用这个,不用根据Id取消
- (void)cancelAllRequests;
- (void)cancelRequestWithRequestId:(NSInteger)requestID;

- (NSString *)serviceType; // 服务器名
- (NSTimeInterval)outdateTimeSeconds;

@end

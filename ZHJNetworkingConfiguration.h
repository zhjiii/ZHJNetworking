//
//  ZHJNetworkingConfiguration.h
//  patient-app
//
//  Created by zhuhongji on 2016/10/21.
//  Copyright © 2016年 zhuhongji. All rights reserved.
//

#ifndef ZHJNetworkingConfiguration_h
#define ZHJNetworkingConfiguration_h

typedef NS_ENUM(NSInteger, ZHJAppType) {
    ZHJAppTypeSoftwareService,
};

//作为底层，请求是否成功只考虑是否成功收到服务器反馈。至于签名是否正确，返回的数据是否完整，由上层的RTApiBaseManager来决定。
typedef NS_ENUM(NSUInteger, ZHJURLResponseStatus){
    ZHJURLResponseStatusSuccess,
    ZHJURLResponseStatusErrorTimeout,
    ZHJURLResponseStatusErrorNoNetwork // 默认除了超时以外的错误都是无网络错误。
};

static NSUInteger kZHJCacheCountLimit = 1000; // 最多1000条cache

static BOOL kIsOnline = YES;

static NSString *kOnlineApiBaseUrl = @"";
static NSString *kOfflineApiBaseUrl = @"";

#endif /* ZHJNetworkingConfiguration_h */

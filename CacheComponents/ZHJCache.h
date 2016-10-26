//
//  ZHJCache.h
//  patient-app
//
//  Created by zhuhongji on 2016/10/24.
//  Copyright © 2016年 zhuhongji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHJCache : NSObject

+ (instancetype)sharedInstance;

- (NSData *)fetchCachedDataWithServiceIdentifier:(NSString *)serviceIdentifier
                                      methodName:(NSString *)methodName
                                   requestParams:(NSDictionary *)requestParams;

- (void)saveCacheWithData:(NSData *)cachedData
        serviceIdentifier:(NSString *)serviceIdentifier
               methodName:(NSString *)methodName
            requestParams:(NSDictionary *)requestParams
       outdateTimeSeconds:(NSTimeInterval)cacheOutdateTimeSeconds;

- (void)deleteCacheWithServiceIdentifier:(NSString *)serviceIdentifier
                              methodName:(NSString *)methodName
                           requestParams:(NSDictionary *)requestParams;

- (NSData *)fetchCachedDataWithKey:(NSString *)key;

- (void)saveCacheWithData:(NSData *)cachedData outdateTimeSeconds:(NSTimeInterval)cacheOutdateTimeSeconds key:(NSString *)key;

- (void)deleteCacheWithKey:(NSString *)key;

- (void)clean;

@end

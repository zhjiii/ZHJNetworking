//
//  ZHJCache.m
//  patient-app
//
//  Created by zhuhongji on 2016/10/24.
//  Copyright © 2016年 zhuhongji. All rights reserved.
//

#import "ZHJCache.h"
#import "ZHJCacheObject.h"
#import "ZHJNetworkingConfiguration.h"
#import "NSDictionary+ZHJNetworkingMethods.h"

@interface ZHJCache ()

@property (nonatomic, strong) NSCache *cache;

@end

@implementation ZHJCache

#pragma mark - life cycle

+ (instancetype)sharedInstance{
    static ZHJCache *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ZHJCache alloc] init];
    });
    return sharedInstance;
}

#pragma mark - public methods

- (void)saveCacheWithData:(NSData *)cachedData serviceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName requestParams:(NSDictionary *)requestParams outdateTimeSeconds:(NSTimeInterval)cacheOutdateTimeSeconds{
    [self saveCacheWithData:cachedData outdateTimeSeconds:cacheOutdateTimeSeconds key:[self keyWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:requestParams]];
}

- (NSData *)fetchCachedDataWithServiceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName requestParams:(NSDictionary *)requestParams{
    return [self fetchCachedDataWithKey:[self keyWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:requestParams]];
}

- (void)deleteCacheWithServiceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName requestParams:(NSDictionary *)requestParams{
    [self deleteCacheWithKey:[self keyWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:requestParams]];
}

#pragma mark - private methods

- (void)saveCacheWithData:(NSData *)cachedData outdateTimeSeconds:(NSTimeInterval)cacheOutdateTimeSeconds key:(NSString *)key{
    ZHJCacheObject *cachedObject = [self.cache objectForKey:key];
    if (!cachedObject) {
        cachedObject = [[ZHJCacheObject alloc] initWithContent:cachedData outdateTimeSeconds:cacheOutdateTimeSeconds];
    }
    [cachedObject updateContent:cachedData];
    [self.cache setObject:cachedObject forKey:key];
}

- (NSData *)fetchCachedDataWithKey:(NSString *)key{
    ZHJCacheObject *cachedObject = [self.cache objectForKey:key];
    if (cachedObject.isOutdated || cachedObject.isEmpty) {
        return nil;
    } else {
        return cachedObject.content;
    }
}

- (void)deleteCacheWithKey:(NSString *)key{
    [self.cache removeObjectForKey:key];
}

- (void)clean{
    [self.cache removeAllObjects];
}

- (NSString *)keyWithServiceIdentifier:(NSString *)serviceIdentifier
                            methodName:(NSString *)methodName
                         requestParams:(NSDictionary *)requestParams{
    return [NSString stringWithFormat:@"%@%@%@", serviceIdentifier, methodName, [requestParams AIF_urlParamsStringSignature]];
}

#pragma mark - get & set

- (NSCache *)cache{
    if (!_cache) {
        _cache = [[NSCache alloc] init];
        _cache.countLimit = kZHJCacheCountLimit;
    }
    return _cache;
}

@end

//
//  ZHJDefaultService.m
//  patient-app
//
//  Created by zhuhongji on 2016/10/21.
//  Copyright © 2016年 zhuhongji. All rights reserved.
//

#import "ZHJDefaultService.h"
#import "ZHJNetworkingConfiguration.h"

@implementation ZHJDefaultService

#pragma mark - ZHYServiceProtocal

- (BOOL)isOnline{
    return kIsOnline;
}

- (NSString *)onlineApiBaseUrl{
    return kOnlineApiBaseUrl;
}

- (NSString *)onlineApiVersion{
    return @"";
}

- (NSString *)onlinePrivateKey{
    return @"";
}

- (NSString *)onlinePublicKey{
    return @"";
}

- (NSString *)offlineApiBaseUrl{
    return kOfflineApiBaseUrl;
}

- (NSString *)offlineApiVersion{
    return self.onlineApiVersion;
}

- (NSString *)offlinePrivateKey{
    return self.onlinePrivateKey;
}

- (NSString *)offlinePublicKey{
    return self.onlinePublicKey;
}

@end

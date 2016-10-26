//
//  ZHJServiceFactory.m
//  patient-app
//
//  Created by zhuhongji on 2016/10/21.
//  Copyright © 2016年 zhuhongji. All rights reserved.
//

#import "ZHJServiceFactory.h"
#import "ZHJDefaultService.h"
#import <objc/runtime.h>

@implementation ZHJServiceFactory

#pragma mark - life cycle

+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    static ZHJServiceFactory *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ZHJServiceFactory alloc] init];
    });
    return sharedInstance;
}

- (ZHJService <ZHJServiceProtocol> *)serviceWithIdentifier:(NSString *)identifier{
    if (!identifier) {
        return [[ZHJDefaultService alloc] init];
    }
    return [[NSClassFromString(identifier) alloc] init];
}

@end

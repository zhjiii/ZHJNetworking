//
//  ZHJServiceFactory.h
//  patient-app
//
//  Created by zhuhongji on 2016/10/21.
//  Copyright © 2016年 zhuhongji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHJService.h"

@interface ZHJServiceFactory : NSObject

+ (instancetype)sharedInstance;

/**
 *  工厂方法根据 identifier 构造不同的service
 *  @param identifier  service 的唯一标识符  在AIFNetworkingConfiguration中定义成全局常量
 */
- (ZHJService <ZHJServiceProtocol> *)serviceWithIdentifier:(NSString *)identifier;

@end

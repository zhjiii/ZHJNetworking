//
//  ZHJAPIProxy.h
//  patient-app
//
//  Created by zhuhongji on 2016/10/21.
//  Copyright © 2016年 zhuhongji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHJURLResponse.h"

@interface ZHJAPIProxy : NSObject

+ (instancetype)sharedInstance;

- (NSInteger)callGETWithParams:(NSDictionary *)params
             serviceIdentifier:(NSString *)servieIdentifier
                    methodName:(NSString *)methodName
             completionHandler:(void (^)(ZHJURLResponse *response, NSError *error))completionHandler;


- (NSInteger)callPOSTWithParams:(NSDictionary *)params
              serviceIdentifier:(NSString *)servieIdentifier
                     methodName:(NSString *)methodName
              completionHandler:(void (^)(ZHJURLResponse *response, NSError *error))completionHandler;

- (void)cancelRequestWithRequestID:(NSNumber *)requestID;

- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList;

@end

//
//  NSURLRequest+Properties.m
//  patient-app
//
//  Created by zhuhongji on 2016/10/21.
//  Copyright © 2016年 zhuhongji. All rights reserved.
//

#import "NSURLRequest+Properties.h"
#import <objc/runtime.h>

static void *ZHJNetworkingRequestParams;

@implementation NSURLRequest (Properties)

- (void)setRequestParams:(NSDictionary *)requestParams{
    objc_setAssociatedObject(self, &ZHJNetworkingRequestParams, requestParams, OBJC_ASSOCIATION_COPY);
}

- (NSDictionary *)requestParams{
    return objc_getAssociatedObject(self, &ZHJNetworkingRequestParams);
}

@end

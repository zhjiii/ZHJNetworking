//
//  NSDictionary+ZHJNetworkingMethods.m
//  patient-app
//
//  Created by zhuhongji on 2016/10/24.
//  Copyright © 2016年 zhuhongji. All rights reserved.
//

#import "NSDictionary+ZHJNetworkingMethods.h"
#import "NSArray+ZHJNetworkingMethods.h"

@implementation NSDictionary (ZHJNetworkingMethods)

- (NSString *)AIF_urlParamsStringSignature{
    NSArray *sortedArray = [self AIF_transformedUrlParamsArraySignature];
    return [sortedArray AX_paramsString];
}

- (NSArray *)AIF_transformedUrlParamsArraySignature{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (![obj isKindOfClass:[NSString class]]) {
            obj = [NSString stringWithFormat:@"%@", obj];
        }
        obj = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,  (CFStringRef)obj,  NULL,  (CFStringRef)@"!*'();:@&;=+$,/?%#[]",  kCFStringEncodingUTF8));
        if ([obj length] > 0) {
            [result addObject:[NSString stringWithFormat:@"%@=%@", key, obj]];
        }
    }];
    NSArray *sortedResult = [result sortedArrayUsingSelector:@selector(compare:)];
    return sortedResult;
}

@end

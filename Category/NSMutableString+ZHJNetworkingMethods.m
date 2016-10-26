//
//  NSMutableString+ZHJNetworkingMethods.m
//  patient-app
//
//  Created by zhuhongji on 2016/10/24.
//  Copyright © 2016年 zhuhongji. All rights reserved.
//

#import "NSMutableString+ZHJNetworkingMethods.h"

@implementation NSMutableString (ZHJNetworkingMethods)

- (void)appendURLRequest:(NSURLRequest *)request
{
    [self appendFormat:@"\n\nHTTP URL:\n\t%@", request.URL];
    [self appendFormat:@"\n\nHTTP Header:\n%@", request.allHTTPHeaderFields ? request.allHTTPHeaderFields : @"\t\t\t\t\tN/A"];
    [self appendFormat:@"\n\nHTTP Body:\n\t%@", [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding] ?:@"\t\t\t\tN/A"];
}


@end

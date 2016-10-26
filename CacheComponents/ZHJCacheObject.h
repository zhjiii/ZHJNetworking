//
//  ZHJCacheObject.h
//  patient-app
//
//  Created by zhuhongji on 2016/10/24.
//  Copyright © 2016年 zhuhongji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHJCacheObject : NSObject

@property (nonatomic, strong, readonly) NSData *content;
@property (nonatomic, strong, readonly) NSDate *lastUpdateTime;

@property (nonatomic, assign, readonly) BOOL isOutdated;
@property (nonatomic, assign, readonly) BOOL isEmpty;

- (instancetype)initWithContent:(NSData *)content;
- (instancetype)initWithContent:(NSData *)content outdateTimeSeconds:(NSTimeInterval)cacheOutdateTimeSeconds;

- (void)updateContent:(NSData *)content;

@end

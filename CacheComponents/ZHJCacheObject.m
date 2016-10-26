//
//  ZHJCacheObject.m
//  patient-app
//
//  Created by zhuhongji on 2016/10/24.
//  Copyright © 2016年 zhuhongji. All rights reserved.
//

#import "ZHJCacheObject.h"

@interface ZHJCacheObject ()

@property (nonatomic, strong, readwrite) NSData *content;
@property (nonatomic, strong, readwrite) NSDate *lastUpdateTime;

@property (nonatomic, assign) NSTimeInterval cacheOutdateTimeSeconds;

@end

@implementation ZHJCacheObject

#pragma mark - life cycle

- (instancetype)initWithContent:(NSData *)content{
    self = [self initWithContent:content outdateTimeSeconds:0];
    return self;
}

- (instancetype)initWithContent:(NSData *)content outdateTimeSeconds:(NSTimeInterval)cacheOutdateTimeSeconds{
    self = [super init];
    if (self) {
        self.content = content;
        self.cacheOutdateTimeSeconds = cacheOutdateTimeSeconds;
    }
    return self;
}

#pragma mark - public method

- (void)updateContent:(NSData *)content{
    self.content = content;
}

#pragma mark - getters and setters

- (BOOL)isEmpty{
    return self.content == nil;
}

- (BOOL)isOutdated{
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastUpdateTime];
    return timeInterval > self.cacheOutdateTimeSeconds;
}

- (void)setContent:(NSData *)content{
    _content = content;
    self.lastUpdateTime = [NSDate dateWithTimeIntervalSinceNow:0];
}

@end

//
// AppMonitorMeasure.h
// 
// UserTrack 
// 开发团队：数据通道团队 
// UT答疑群：11791581(钉钉) 
// UT埋点平台答疑群：11779226(钉钉) 
// 
// Copyright (c) 2014-2017 Taobao. All rights reserved. 
//

#import <Foundation/Foundation.h>
#import <UT/AppMonitorMeasureValue.h>

/**
 * 监控指标项
 *
 */
NS_ASSUME_NONNULL_BEGIN
@interface AppMonitorMeasure : NSObject<NSCoding>

@property (nonatomic, copy) NSString    *name;
@property (nonatomic, strong) NSNumber  *constantValue;
@property (nonatomic, strong) NSNumber  *min;
@property (nonatomic, strong) NSNumber  *max;
@property (nonatomic, copy) NSArray     *bounds;

- (instancetype)initWithName:(nullable NSString *)name;

- (instancetype)initWithName:(nullable NSString *)name constantValue:(nullable NSNumber *)constantValue;

- (instancetype)initWithName:(nullable NSString *)name constantValue:(nullable NSNumber *)constantValue min:(nullable NSNumber *)min max: (nullable NSNumber *)max;

- (instancetype)initWithName:(nullable NSString *)name constantValue:(nullable NSNumber *)constantValue bounds:(nullable NSArray *)bounds;

- (void)setRangeWithMin:(NSNumber *)min max:(NSNumber *)max;

- (BOOL)valid:(AppMonitorMeasureValue *)measureValue;
@end
NS_ASSUME_NONNULL_END

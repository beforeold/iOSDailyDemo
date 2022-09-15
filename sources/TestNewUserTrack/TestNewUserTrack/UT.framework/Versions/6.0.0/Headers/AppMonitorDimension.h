//
// AppMonitorDimension.h
// 
// UserTrack 
// 开发团队：数据通道团队 
// UT答疑群：11791581(钉钉) 
// UT埋点平台答疑群：11779226(钉钉) 
// 
// Copyright (c) 2014-2017 Taobao. All rights reserved. 
//

#import <Foundation/Foundation.h>

/**
 * 监控维度
 *
 */
NS_ASSUME_NONNULL_BEGIN
@interface AppMonitorDimension : NSObject<NSCoding>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *constantValue;

- (instancetype)initWithName:(nullable NSString *)name;

- (instancetype)initWithName:(nullable NSString *)name constantValue:(nullable NSString *)constantValue;

@end
NS_ASSUME_NONNULL_END

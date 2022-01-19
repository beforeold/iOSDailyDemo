//
// AppMonitorMeasureValue.h
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
 * 监控指标值
 *
 */
NS_ASSUME_NONNULL_BEGIN

@interface AppMonitorMeasureValue : NSObject

/**
 * 耗时操作是否已经完成
 */
@property (nonatomic, assign) BOOL isFinish;
@property (nonatomic, strong) NSNumber * offset;
@property (nonatomic, strong) NSNumber * value;//TODO 改成readonly

- (instancetype)initWithValue:(nullable NSNumber * )value;
- (instancetype)initWithValue:(nullable NSNumber *)value offset:(nullable NSNumber *)offset;
- (void)merge:(AppMonitorMeasureValue *)measureValue;
//为了json序列化
- (NSDictionary *)jsonDict;
//json反序列化
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (void)setBounds:(NSArray *)bounds;

@end
NS_ASSUME_NONNULL_END

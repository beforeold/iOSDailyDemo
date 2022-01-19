//
// AppMonitorMeasureValueSet.h
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
NS_ASSUME_NONNULL_BEGIN
@interface AppMonitorMeasureValueSet : NSObject<NSCopying>

/**
 * 存储指标值 Map<String, MeasureValue>
 */
@property (nonatomic, strong) NSMutableDictionary *dict;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;


/**
 * 设置指标值
 *
 * @param name name
 * @param value value
 */
- (void)setDoubleValue:(double)value forName:(NSString *)name;
- (void)setValue:(AppMonitorMeasureValue *)value forName:(NSString *)name;
- (BOOL)containValueForName:(NSString *)name;
- (AppMonitorMeasureValue *)valueForName:(NSString *)name;
/**
 *  合并指标
 *
 *  @param measureValueSet 目标指标集合
 *  发现相同的name就对MeasureValue做加操作
 */
- (void)merge:(AppMonitorMeasureValueSet*)measureValueSet;

- (NSDictionary *)jsonDict;

@end
NS_ASSUME_NONNULL_END

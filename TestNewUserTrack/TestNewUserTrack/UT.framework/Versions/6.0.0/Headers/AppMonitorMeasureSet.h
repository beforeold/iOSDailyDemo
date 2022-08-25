//
// AppMonitorMeasureSet.h
// 
// UserTrack 
// 开发团队：数据通道团队 
// UT答疑群：11791581(钉钉) 
// UT埋点平台答疑群：11779226(钉钉) 
// 
// Copyright (c) 2014-2017 Taobao. All rights reserved. 
//

#import <Foundation/Foundation.h>
#import <UT/AppMonitorMeasure.h>
#import <UT/AppMonitorMeasureValueSet.h>
NS_ASSUME_NONNULL_BEGIN
@interface AppMonitorMeasureSet : NSObject<NSCoding>

/**
 * 根据列表初始化指标集合对象
 *
 * @param array NSString类型的数组 string为Name;
 * @return instance
 */

+ (instancetype)setWithArray:(NSArray *)array;

- (BOOL)valid:(NSString*)module MonitorPoint:(NSString*)monitorpoint measureValues:(AppMonitorMeasureValueSet *)measureValues;
/**
 * 增加指标
 *
 * @param measure 指标对象
 */
- (void)addMeasure:(AppMonitorMeasure *)measure;

/**
 * 增加指标对象
 *
 * @param name 指标名称
 */
- (void)addMeasureWithName:(NSString *)name;
/**
 * 获取指标对象
 *
 * @param name 指标名称
 * @return AppMonitorMeasure
 */
- (AppMonitorMeasure *)measureForName:(NSString *)name;

/**
 * 获取指标对象的列表
 *
 * @return measures
 */
- (NSMutableOrderedSet *)measures;

/**
 * 设置定值维度
 *
 * @param measureValues key为指标名称，value为内容
 */
- (void)setConstantValue:(AppMonitorMeasureValueSet *)measureValues;

@end
NS_ASSUME_NONNULL_END

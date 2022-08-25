//
// AppMonitorDimensionSet.h
// 
// UserTrack 
// 开发团队：数据通道团队 
// UT答疑群：11791581(钉钉) 
// UT埋点平台答疑群：11779226(钉钉) 
// 
// Copyright (c) 2014-2017 Taobao. All rights reserved. 
//

#import <Foundation/Foundation.h>
#import <UT/AppMonitorDimensionValueSet.h>
#import <UT/AppMonitorDimension.h>
NS_ASSUME_NONNULL_BEGIN
@interface AppMonitorDimensionSet : NSObject<NSCoding>

/**
 * 根据列表初始化指标集合对象
 *
 * @param array NSString类型的数组 string为Name;
 * @return instance
 */

+ (instancetype)setWithArray:(NSArray *)array;

- (BOOL)valid:(AppMonitorDimensionValueSet*)dimensionValues;
/**
 * 增加维度
 *
 * @param dimension 维度对象
 */
- (void)addDimension:(AppMonitorDimension *)dimension;

/**
 * 增加维度对象
 *
 * @param name 维度名称
 */
- (void)addDimensionWithName:(NSString *)name;
/**
 * 获取维度对象
 *
 * @param name 维度名称
 * @return AppMonitorDimension
 */
- (AppMonitorDimension *)dimensionForName:(NSString *)name;

- (NSMutableOrderedSet *)dimensions;

/**
 * 设置定值维度
 *
 * @param dimensionValues key为维度名称，value为内容
 */
- (void)setConstantValue:(AppMonitorDimensionValueSet *)dimensionValues;

@end
NS_ASSUME_NONNULL_END

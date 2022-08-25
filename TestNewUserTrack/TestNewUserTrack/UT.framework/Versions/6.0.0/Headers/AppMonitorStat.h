//
// AppMonitorStat.h
// 
// UserTrack 
// 开发团队：数据通道团队 
// UT答疑群：11791581(钉钉) 
// UT埋点平台答疑群：11779226(钉钉) 
// 
// Copyright (c) 2014-2017 Taobao. All rights reserved. 
//

#import <Foundation/Foundation.h>
#import <UT/AppMonitorBase.h>
#import <UT/AppMonitorMeasureSet.h>
#import <UT/AppMonitorDimensionSet.h>
NS_ASSUME_NONNULL_BEGIN
@interface AppMonitorStatTransaction :NSObject

- (void)beginWithMeasureName:(NSString *)measureName;

- (void)endWithMeasureName:(NSString *)measureName;

@end

@interface AppMonitorStat : AppMonitorBase

/**
 * 注册性能埋点
 * @param module 模块
 * @param monitorPoint 监控点
 * @param measures 多指标
 */
+ (void)registerWithModule:(NSString *)module monitorPoint:(NSString *)monitorPoint measureSet:(nullable AppMonitorMeasureSet *)measures;

/**
 * 注册性能埋点
 * @param module 模块
 * @param monitorPoint 监控点
 * @param measures 多指标
 * @param dimensions 多维度
 */
+ (void)registerWithModule:(NSString *)module monitorPoint:(NSString *)monitorPoint measureSet:(nullable AppMonitorMeasureSet *)measures dimensionSet:(nullable AppMonitorDimensionSet *)dimensions;

/**
 * 注册性能埋点
 * @param module 模块
 * @param monitorPoint 监控点
 * @param measures 多指标
 * @param detail 标记是否提交明细。需要提交明细时设置为YES，否则为NO
 */
+ (void)registerWithModule:(NSString *)module monitorPoint:(NSString *)monitorPoint measureSet:(nullable AppMonitorMeasureSet *)measures isCommitDetail:(BOOL)detail;

/**
 * 注册性能埋点
 * @param module 模块
 * @param monitorPoint 监控点
 * @param measures 多指标
 * @param dimensions 多维度
 * @param detail 标记是否提交明细。需要提交明细时设置为YES，否则为NO
 */
+ (void)registerWithModule:(NSString *)module monitorPoint:(NSString *)monitorPoint measureSet:(nullable AppMonitorMeasureSet *)measures dimensionSet:(nullable AppMonitorDimensionSet *)dimensions isCommitDetail:(BOOL)detail;

/**
 * 注册性能埋点
 * @param module 模块
 * @param monitorPoint 监控点
 * @param measures 多指标
 * @param dimensions 多维度
 * @param detail 标记是否提交明细。需要提交明细时设置为YES，否则为NO
 * @param isOffline 是否离线
 */
+ (void)registerWithModule:(NSString *)module monitorPoint:(NSString *)monitorPoint measureSet:(nullable AppMonitorMeasureSet *)measures dimensionSet:(nullable AppMonitorDimensionSet *)dimensions isCommitDetail:(BOOL)detail offline:(BOOL)isOffline;

/**
 * 提交多维度，多指标
 * @param module 监控模块
 * @param monitorPoint 监控点名称 Page+monitorPoint必须唯一
 * @param dimensionValues 维度值集合
 * @param measureValues 指标值集合
 */
+ (void)commitWithModule:(NSString*) module monitorPoint:(NSString *)monitorPoint dimensionValueSet:(nullable AppMonitorDimensionValueSet *)dimensionValues measureValueSet:(nullable AppMonitorMeasureValueSet *)measureValues;

/**
 * 提交多维度单指标
 * @param module 监控模块
 * @param monitorPoint 监控点名称 Page+monitorPoint必须唯一
 * @param dimensionValues 维度值集合
 * @param value 指标值
 */

+ (void)commitWithModule:(NSString*) module monitorPoint:(NSString *)monitorPoint dimensionValueSet:(nullable AppMonitorDimensionValueSet *)dimensionValues value:(double)value;

/**
 * 提交单指标
 * @param module 监控模块
 * @param monitorPoint 监控点名称 Page+monitorPoint必须唯一
 * @param value 指标值
 */
+ (void)commitWithModule:(NSString*) module monitorPoint:(NSString *)monitorPoint value:(double)value;

/**
 *开始事件,适合不存在并发的跨多线程事件（比如常见的UI加载渲染）<br/>
 *如果事件跨多线程多并发执行,请使用beginTransaction-endTransaction方法对，此场景较少见
 * @param module 监控模块
 * @param monitorPoint 监控点名称 module+monitorPoint必须唯一
 */
+ (void)beginWithModule:(NSString *)module monitorPoint:(NSString *)monitorPoint measureName:(NSString *)measureName;

/**
 *结束事件，适合不存在并发的跨多线程事件（比如常见的UI加载渲染）<br/>
 *如果事件跨多线程多并发执行,请使用beginTransaction-endTransaction方法对，此场景较少见
 * @param module 监控模块
 * @param monitorPoint 监控点名称 module+monitorPoint必须唯一
 */
+ (void)endWithModule:(NSString *)module monitorPoint:(NSString *)monitorPoint measureName:(NSString *)measureName;

/**
 * 埋点事务,可以通过调用事务的begin-end方法对来统计耗时指标的值
 *
 * @param module 模块
 * @param monitorPoint 监控点
 * @return 返回埋点事务实例
 */

+ (AppMonitorStatTransaction *)createTransactionWithModule:(NSString *)module monitorPoint:(NSString *)monitorPoint;

@end




NS_ASSUME_NONNULL_END

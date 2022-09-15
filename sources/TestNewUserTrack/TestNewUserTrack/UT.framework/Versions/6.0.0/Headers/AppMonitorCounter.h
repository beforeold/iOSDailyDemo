//
// AppMonitorCounter.h
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
NS_ASSUME_NONNULL_BEGIN
@interface AppMonitorCounter : AppMonitorBase

/**
 *  实时计数接口.（每次commit会累加一次count，value也会累加）可用于服务端计算总次数或求平均值。
 *  此接口数据量不应太大，
 *
 *  @param page         操作发生所在的页面
 *  @param monitorPoint 监控点名称
 *  @param value        数值
 */
+ (void)commitWithPage:(NSString *)page monitorPoint:(NSString *)monitorPoint value:(double)value;

/**
 *  实时计数接口.（每次commit会累加一次count，value也会累加）可用于服务端计算总次数或求平均值。
 *  此接口数据量不应太大，
 *
 *  @param page         操作发生所在的页面
 *  @param monitorPoint 监控点名称
 *  @param value        数值
 *  @param arg          附加参数
 */
+ (void)commitWithPage:(NSString *)page monitorPoint:(NSString *)monitorPoint value:(double)value arg:(nullable NSString *)arg;

@end
NS_ASSUME_NONNULL_END

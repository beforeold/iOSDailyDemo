//
// AppMonitorOffLineCounter.h
// 
// UserTrack 
// 开发团队：数据通道团队 
// UT答疑群：11791581(钉钉) 
// UT埋点平台答疑群：11779226(钉钉) 
// 
// Copyright (c) 2014-2017 Taobao. All rights reserved. 
//

#import <UT/AppMonitorCounter.h>
NS_ASSUME_NONNULL_BEGIN
@interface AppMonitorOffLineCounter : AppMonitorCounter

/**
 *  离线计数接口.（每次commit会累加一次count，value也会累加）可用于服务端离线计算数据量较大的总次数或求平均值
 *
 *  @param page         操作发生所在的页面
 *  @param monitorPoint 监控点名称
 *  @param value        数值
 */
+ (void)commitWithPage:(NSString *)page monitorPoint:(NSString *)monitorPoint value:(double)value;

@end
NS_ASSUME_NONNULL_END

//
// AppMonitorBase.h
// 
// UserTrack 
// 开发团队：数据通道团队 
// UT答疑群：11791581(钉钉) 
// UT埋点平台答疑群：11779226(钉钉) 
// 
// Copyright (c) 2014-2017 Taobao. All rights reserved. 
//

#import <Foundation/Foundation.h>

@interface AppMonitorBase : NSObject
/**
 *  日志写入UT间隔时间(单位秒).默认300秒, -1代表关闭. 会监听配置中心做变化
 */
+ (void)setWriteLogInterval:(NSInteger)writeLogInterval;

+ (NSInteger)writeLogInterval;

@end

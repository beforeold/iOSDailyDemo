//
// AppMonitor.h
// 
// UserTrack 
// 开发团队：数据通道团队 
// UT答疑群：11791581(钉钉) 
// UT埋点平台答疑群：11779226(钉钉) 
// 
// Copyright (c) 2014-2017 Taobao. All rights reserved. 
//

#import <Foundation/Foundation.h>
#import <UT/AppMonitorAlarm.h>
#import <UT/AppMonitorCounter.h>
#import <UT/AppMonitorStat.h>
#import <UT/AppMonitorOffLineCounter.h>
#import <UT/AppMonitorTable.h>
#import <UT/AppMonitorMeasure.h>
#import <UT/AppMonitorMeasureSet.h>
#import <UT/AppMonitorDimension.h>
#import <UT/AppMonitorDimensionSet.h>
#import <UT/AppMonitorMeasureValue.h>
NS_ASSUME_NONNULL_BEGIN
@interface AppMonitor : NSObject

/**
 *  在使用UT且有安全黑匣子加密的情况下，不需要调用此接口，APPMonitor会跟UT共享APPKEY。否则，
 *  使用前务必调用此方法，传入的appkey和secret同样适用于UT版本
 *  申请地址：http://open.taobao.com
 *  @param appkey
 *  @param appSecret
 */
//+ (void)setUTAppKey:(NSString *)appkey secret:(NSString *)appSecret;


/**
 *  设置淘宝配置中心的app 参数用来同步配置用
 *
 *  @param appKey
 *  @param appSecret
 */
//+ (void)setTBCAppkey:(NSString *)appKey secret:(NSString *)appSecret environment:(TBSDKEnvironment)e;

/**
 *  设置配置中心配置文件的名字和key
 *
 *  @param fileName  文件名字
 *  @param key       对应的配置key
 */
//+ (void)setTBCFileName:(NSString *)fileName key:(NSString *)key;

//+ (BOOL)isInit;

//+ (instancetype)sharedInstance;

/**
 *  开启release模式，关闭所有日志
 */

//+ (void)turnOnRelease;

/**
 *  设置渠道，可以用来做区分
 */

//+ (void)setChannel:(NSString *)channel;

/**
 *  设置用户ID
 *  在定位问题的时候可以从UT的log中找到对于用户
 */
//+ (void)setUserID:(NSString *)userid;

/**
 *  设置用户nick
 *  在定位问题的时候可以从UT的log中找到对于用户
 *  @param userNick 用户昵称
 */
//+ (void)setUserNick:(NSString *)userNick;

/**
 *
 *  提交自定义的的性能埋点（范围在性能埋点的id范围内）
 *  业务埋点，请走UT。
 */
//+ (void)comimtEvent:(NSString *)eventid arg1:(NSString *)arg1 arg2:(NSString *)arg2 arg3:(NSString *)arg3 dict:(NSDictionary *)pDict;


///////////////////////////////////////////////////////////////////////////////
////////////////////////////   以下API 为测试人员专用API  ////////////////////////
///////////////////////////////////////////////////////////////////////////////

/**
 *  开启debug模式，能够打印接收到的日志.
 */
+ (void)turnOnDebug NS_DEPRECATED_IOS(2_0, 6_0, "Use UTAnalytics.turnOnDebug instead");

/**
 *  当前的开发模式，默认为开发模式
 */
//+ (AMDevMode)currentMode;

/**
 *  设置log的level
 */
//+ (void)setLogLevel:(AMLogLevel)ll;


/**
 *  关闭采样，紧开发调试用。线上版本请勿调用此API
 */
+ (void)disableSample;

/**
 *  设置采样率(默认是 50%) 值范围在[0~10000] (0表示不上传，10000表示100%上传，5000表示50%上传)
 */
+ (void)setSampling:(NSString *)sampling;

/**
 *  设置环境 Daily和线上 环境切换。数据整合在meta字段
 */
//+ (void)setDailyEnvironment;

////是否开启实时调试模式（与UT同步）
//+ (BOOL)isTurnOnRealTimeDebug;
//+ (NSString*)realTimeDebugUploadUrl;
//+ (NSString*)realTimeDebugId;

+(void) turnOnAppMonitorRealtimeDebug:(NSDictionary *) pDict;
+(void) turnOffAppMonitorRealtimeDebug;


/**
 *  appmonitor 全局打标
 *  相同的key会覆盖
 */
+(void) setGlobalProperty:(NSString *) pKey value:(NSString *) pValue;
+(void) removeGlobalProperty:(NSString *) pKey;
+(NSString *) getGlobalProperty:(NSString *) pKey;
@end
NS_ASSUME_NONNULL_END

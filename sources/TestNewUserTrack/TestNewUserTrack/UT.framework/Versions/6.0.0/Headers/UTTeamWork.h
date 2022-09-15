//
// UTTeamWork.h
// 
// UserTrack 
// 开发团队：数据通道团队 
// UT答疑群：11791581(钉钉) 
// UT埋点平台答疑群：11779226(钉钉) 
// 
// Copyright (c) 2014-2017 Taobao. All rights reserved. 
//

#import <Foundation/Foundation.h>
#import <UT/UTExposureViewProtocol.h>
NS_ASSUME_NONNULL_BEGIN
@interface UTTeamWork : NSObject

+(void) turnOnRealTimeDebug:(NSDictionary *) pDict;

+(void) trunOffRealTimeDebug;

+ (void)setConfigMgr:(NSDictionary *) pDict withNameSpace: (NSString *) pName isUpdate:(BOOL) isUpdate;

+ (void)setHasOrange;

//UT内部已经可以判断是二方的安全黑匣子还是三方的安全黑匣子
//该接口已经被空实现，无需调用了
+ (void)appIsOpenSet __deprecated;

/**
 * @brief            自定义https上传域名
 *
 * @param     url    指定的https上传域名，比如以https://开头
 *
 * @warning   调用说明:需要在初始化UT之前调用(setAppkey之前)
 */
+ (void)setHttpsUploadUrl:(NSString *)url;

/**
 * @brief            自定义tnet上传域名
 *
 * @param     host    指定的tnet上传域名
 * @param     port    指定的tnet上传端口
 *
 * @warning   调用说明:需要在初始化UT之前调用(setAppkey之前)
 */
+ (void)setTnetHost:(NSString *)host por:(unsigned int)port;

+ (void)registerExposureViewHandler:(id<UTExposureViewProtocol>)handler;

+ (id<UTExposureViewProtocol>)utExposureViewHandler;

+ (void)unregisterExposureViewHandler:(id<UTExposureViewProtocol>)handler;

/*
 * 忽略当前视图下所有视图的曝光。扫描时遇见该标志时，该视图及视图以下所有子视图均被忽略，不会被计算；
 * @param view
 */
+ (void)setIgnoreTagForExposureView:(UIView *) view;

/*
 * 清除View的Ignore标记。View及以下所有子View都会被扫描到，和setIgnoreTagForExposureView:(UIView *) view对应
 * @param view
 */
+ (void)clearIgnoreTagForExposureView:(UIView *) view;
@end
NS_ASSUME_NONNULL_END

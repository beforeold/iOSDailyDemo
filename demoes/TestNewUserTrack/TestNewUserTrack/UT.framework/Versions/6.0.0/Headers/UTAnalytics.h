//
// UTAnalytics.h
// 
// UserTrack 
// 开发团队：数据通道团队 
// UT答疑群：11791581(钉钉) 
// UT埋点平台答疑群：11779226(钉钉) 
// 
// Copyright (c) 2014-2017 Taobao. All rights reserved. 
//

#import <Foundation/Foundation.h>
#import <UT/UTTracker.h>
#import <UT/UTPlugin.h>
#import <UT/UTIRequestAuthentication.h>
extern NSString * _Nonnull const UTSessionChangedNotification;

NS_ASSUME_NONNULL_BEGIN
@interface UTAnalytics : NSObject

+(UTAnalytics *) getInstance;

#pragma mark - ut initialization function

/**
 * @brief                       if depend on SecurityGuard, use this func to initialize ut
 *
 * @param       appKey          appkey
 *
 */
- (BOOL) setAppKey:(NSString *)appKey;

/**
 * @brief                       if depend on SecurityGuard, the securityGuard picture has one more appkey
 *                              and your appkey is not the first position in the securityGuard picture
 *                              use this func to initialize ut
 *
 * @param       appKey          appkey
 *
 * @param       index_number    the index of appkey in the securityGuard picture
 *
 */
- (BOOL) setAppKey:(NSString *)appKey index:(int) index_number;

/**
 * @brief                       if not depend on SecurityGuard, use appkey-appsecret to initialize ut
 *
 */
- (BOOL) setAppKey:(NSString *)appKey secret:(NSString *)secret;

/** initialize func which is abandoned，Empty implementation!! */
- (void) setRequestAuthentication:(id<UTIRequestAuthentication>)pRequestAuth NS_DEPRECATED_IOS(2_0, 6_0, "Use setAppKey:secret: instead");


#pragma mark set app info
-(void) setAppVersion:(NSString *) pAppVersion;

-(void) setChannel:(NSString *) pChannel;

/**
 * @brief                       login event track, eventid = 1007
 *
 * @param       pNick           login nickname
 *
 * @param       pUserId         login userid
 *
 */
-(void) updateUserAccount:(NSString *) pNick userid:(nullable NSString *) pUserId;

/**
 更新用户信息，传@""或者nil置空

 @param uid userId
 @param userNick userNick
 @param uidDigest openId
 */
- (void)updateUserCount:(NSString *)uid andUserNick:(NSString *)userNick andDigest:(NSString *)uidDigest;

/**
 * @brief                       user registration event track, eventid = 1006
 *
 * @param       pUsernick       login nickname
 *
 */
-(void) userRegister:(NSString *) pUsernick;


#pragma mark get uttracker
-(UTTracker *) getDefaultTracker;

-(UTTracker *) getTracker:(NSString *)  pTrackId;


#pragma mark ut log
/** ut log level: all < debug < info < warning < error */

/**
 * @brief                       turn on ut log for debug level
 *
 */
-(void) turnOnDebug;

/**
 * @brief                       turn on ut log for info level
 *
 */
-(void) turnOnUTInfo;

/**
 * @brief                       turn off ut log for all level
 *
 */
-(void) turnOffAllUTLog;

#pragma mark ut plugin

+ (void)registerPlugin:(NSObject<UTPlugin> *)plugin;

+ (void)unregisterPlugin:(NSObject<UTPlugin> *)plugin;

#pragma mark other

/**
 * @brief                       openurl for ut realtimedebug
 *
 */
+ (BOOL) handleUrl:(NSURL *)url;

-(void) turnOffCrashHandler;

+(NSString *) utsid;

-(void) updateSessionProperties:(NSDictionary *) pDict;

/**
* @brief  iOS14 读取 idfa通知
*
*/
+ (void)checkImsi;






@end
NS_ASSUME_NONNULL_END

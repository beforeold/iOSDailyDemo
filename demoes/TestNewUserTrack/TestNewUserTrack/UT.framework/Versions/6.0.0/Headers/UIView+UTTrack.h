//
// UIView+UTTrack.h
// 
// UserTrack 
// 开发团队：数据通道团队 
// UT答疑群：11791581(钉钉) 
// UT埋点平台答疑群：11779226(钉钉) 
// 
// Copyright (c) 2014-2017 Taobao. All rights reserved. 
//

#ifndef UTSDK_UIView_UTTrack_h
#define UTSDK_UIView_UTTrack_h
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIView(UTTrackHook)

@property(nonatomic, retain ,nullable) NSString *utActionName;
@property(nonatomic, retain ,nullable) NSDictionary *utArgs;
@property(nonatomic, retain ,nullable) NSURL *utNavUrl;
@property(nonatomic, retain ,nullable) NSString * utPageNameAlias;// 页面别名

#pragma mark - spm-pre专用
/** 新增spm-pre属性 */
@property (nonatomic, copy ,nullable)   NSString *utSpmPre;
@property (nonatomic, copy ,nullable)   NSString *utSpmUrl;
@property (nonatomic, copy ,nullable)   NSString *utSpmCnt;
/** 默认进入的spm-pre-next值，用于privateNextPageProperties中的数据被销毁之后 用于复原 */
@property (nonatomic, copy ,nullable)   NSString *utSpmPreNext;
@property (nonatomic, copy ,nullable)   NSArray *utSpmSeq;
@property (nonatomic, copy ,nullable)   NSArray *utSpmSeqNext;

#pragma mark - utParam带两步专用
/** 新增utparam属性 */
@property (nonatomic, copy ,nullable)   NSString *utParamPre;
@property (nonatomic, copy ,nullable)   NSString *utParamUrl;
@property (nonatomic, copy ,nullable)   NSString *utParamCnt;
/** 默认进入的utparam-pre-next值，用于privateNextPageProperties中的数据被销毁之后 用于复原 */
@property (nonatomic, copy ,nullable)   NSString *utParamPreNext;

#pragma mark - scm专用
@property (nonatomic, copy ,nullable)   NSString *utScmPre;
@property (nonatomic, copy ,nullable)   NSString *utScmUrl;
@property (nonatomic, copy ,nullable)   NSString *utScmPreNext;

@end


#endif

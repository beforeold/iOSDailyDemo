//
// UIViewController+UTTrack.h
// 
// UserTrack 
// 开发团队：数据通道团队 
// UT答疑群：11791581(钉钉) 
// UT埋点平台答疑群：11779226(钉钉) 
// 
// Copyright (c) 2014-2017 Taobao. All rights reserved. 
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/** 是否为VC或者View */
#define UT_IS_VC_OR_VIEW(object) ([object isKindOfClass:[UIViewController class]] || [object isKindOfClass:[UIView class]])
/** 是否为VC */
#define UT_IS_VC(object) ([object isKindOfClass:[UIViewController class]])
/** 是否为VIew */
#define UT_IS_VIEW(object) ([object isKindOfClass:[UIView class]])

typedef NS_ENUM(NSUInteger, UTPageSwitchType){
    UTPageSwitchTypeNone = 0,
    UTPageSwitchTypePush,   //1
    UTPageSwitchTypePop,  //2
    UTPageSwitchTypeTab  //3
};
@interface UIViewController(UTTrackHook)

@property(nonatomic, retain ,nullable) NSString *utActionName;
@property(nonatomic, retain ,nullable) NSDictionary *utArgs;
@property(nonatomic, retain ,nullable) NSURL *utNavUrl;
@property(nonatomic, retain ,nullable) NSDictionary *utProperties;
@property(nonatomic, retain ,nullable) NSDictionary *utPageProperties;
@property(nonatomic, retain ,nullable) NSString * utPageNameAlias;// 页面别名
@property(nonatomic,retain ,nullable) NSString * utH5HasCalled;
@property(nonatomic,retain ,nullable) NSString * utHasAppeared;

#pragma mark - spm-pre专用
/** 新增spm-pre属性 */
@property (nonatomic, copy ,nullable)   NSString *utSpmPre;
@property (nonatomic, copy ,nullable)   NSString *utSpmUrl;
@property (nonatomic, copy ,nullable)   NSString *utSpmCnt;
@property (nonatomic, copy ,nullable)   NSArray *utSpmSeq;
/** 默认进入的spm-pre-next值，用于privateNextPageProperties中的数据被销毁之后 用于复原 */
@property (nonatomic, copy ,nullable)   NSString *utSpmPreNext;
@property (nonatomic, copy ,nullable)   NSArray *utSpmSeqNext;

#pragma mark - utParam带两步专用
/** 新增utParam属性 */
@property (nonatomic, copy ,nullable)   NSString *utParamPre;
@property (nonatomic, copy ,nullable)   NSString *utParamUrl;
@property (nonatomic, copy ,nullable)   NSString *utParamCnt;
/** 默认进入的utparam-pre-next值，用于privateNextPageProperties中的数据被销毁之后 用于复原 */
@property (nonatomic, copy ,nullable)   NSString *utParamPreNext;

#pragma mark - scm专用
@property (nonatomic, copy ,nullable)   NSString *utScmPre;
@property (nonatomic, copy ,nullable)   NSString *utScmUrl;
@property (nonatomic, copy ,nullable)   NSString *utScmPreNext;

/** 是否为返回 */
@property (nonatomic, assign) BOOL utIsbk;
/** 是否设置返回，如果设置为返回，不执行返回判断逻辑，直接执行返回计算逻辑 */
@property (nonatomic, assign) BOOL utIsbkManually;
/** 是否present了一个新VC */
@property (nonatomic, assign) BOOL utPresentNew;

@property (nonatomic, assign) UTPageSwitchType utPageSwitchType;

/** 仅限于H5调用 */
- (void)ut_h5UpdateSpmInfo:(nullable NSDictionary *)spmInfo;
- (void)ut_h5UpdateScmInfo:(nullable NSDictionary *)scmInfo;

/** 当前VC的navi */
- (nullable UINavigationController *)ut_correctNavigationController;
- (nullable UIViewController *)ut_correctPresentedViewController;

/** 是否为子VC */
- (BOOL)ut_isChildViewController;

/** 是否为返回状态 */
- (BOOL)ut_isBackWithStackLength:(NSInteger)stackLength;
- (BOOL)ut_isBackWithStackLength:(NSInteger)stackLength navi:(nullable UINavigationController *)navi;
/** 判断是否手淘导航 */
- (BOOL)isUseTBNav;
@end

//
// UTControlHitBuilder.h
// 
// UserTrack 
// 开发团队：数据通道团队 
// UT答疑群：11791581(钉钉) 
// UT埋点平台答疑群：11779226(钉钉) 
// 
// Copyright (c) 2014-2017 Taobao. All rights reserved. 
//



#import "UTHitBuilder.h"
NS_ASSUME_NONNULL_BEGIN
@interface UTControlHitBuilder : UTHitBuilder

-(instancetype) initWithCtrlName:(NSString *) pCtrlName;

-(instancetype) initWithPageName:(NSString *) pPageName CtrlName:(NSString *) pCtrlName;


@end

NS_ASSUME_NONNULL_END

//
// UTOirginalCustomHitBuilder.h
// 
// UserTrack 
// 开发团队：数据通道团队 
// UT答疑群：11791581(钉钉) 
// UT埋点平台答疑群：11779226(钉钉) 
// 
// Copyright (c) 2014-2017 Taobao. All rights reserved. 
//

#import <Foundation/Foundation.h>
#import <UT/UTHitBuilder.h>

@interface UTOirginalCustomHitBuilder : UTHitBuilder

-(void) setPageName:(nullable NSString *) pPage;

-(void) setEventId:(nullable NSString *) pEventId;

-(void) setArg1:(nullable NSString *) pArg1;

-(void) setArg2:(nullable NSString *) pArg2;

-(void) setArg3:(nullable NSString *) pArg3;

-(void) setArgs:(nullable NSDictionary *) pArgs;

@end

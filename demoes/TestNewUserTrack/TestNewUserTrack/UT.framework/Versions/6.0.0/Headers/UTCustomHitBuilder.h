//
// UTCustomHitBuilder.h
// 
// UserTrack 
// 开发团队：数据通道团队 
// UT答疑群：11791581(钉钉) 
// UT埋点平台答疑群：11779226(钉钉) 
// 
// Copyright (c) 2014-2017 Taobao. All rights reserved. 
//

#import <UT/UTHitBuilder.h>
NS_ASSUME_NONNULL_BEGIN
@interface UTCustomHitBuilder : UTHitBuilder

-(void) setEventLabel:(NSString *) pEventId;

-(void) setEventPage:(NSString *) pPageName;

-(void) setDurationOnEvent:(long long) durationOnEvent;

@end
NS_ASSUME_NONNULL_END

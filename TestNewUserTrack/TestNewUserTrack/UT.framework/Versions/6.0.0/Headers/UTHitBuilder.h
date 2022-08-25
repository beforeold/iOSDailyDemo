//
// UTHitBuilder.h
// 
// UserTrack 
// 开发团队：数据通道团队 
// UT答疑群：11791581(钉钉) 
// UT埋点平台答疑群：11779226(钉钉) 
// 
// Copyright (c) 2014-2017 Taobao. All rights reserved. 
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface UTHitBuilder : NSObject


-(NSDictionary *) build;

-(void) setProperty:(NSString *) pKey value:(NSString *) pValue;

-(void) setProperties:(NSDictionary *) pPageProperties;

@end
NS_ASSUME_NONNULL_END

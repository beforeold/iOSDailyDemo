//
// UTPlugin.h
// 
// UserTrack 
// 开发团队：数据通道团队 
// UT答疑群：11791581(钉钉) 
// UT埋点平台答疑群：11779226(钉钉) 
// 
// Copyright (c) 2014-2017 Taobao. All rights reserved. 
//

#import <Foundation/Foundation.h>

/**
 UTPlugin为特殊接口，一般为UT内部自用，误用会造成重大影响，使用前必须联系@苍井、@芮奇
 */
@protocol UTPlugin <NSObject>

- (nullable NSSet *)getAttentionEventIds;
- (nonnull NSString *)pluginName;
@optional
//argsString或者argsDict 仅会执行其中一个方法 ,优先使用argsDict
- (nullable NSDictionary *)onBeforeEventDispatchWithPage:(nullable NSString *)page
                                        eventId:(nullable NSString *)eventId
                                           arg1:(nullable NSString *)arg1
                                           arg2:(nullable NSString *)arg2
                                           arg3:(nullable NSString *)arg3
                                           args:(nullable NSString *)args;

- (nullable NSDictionary *)onBeforeEventDispatchWithPage:(nullable NSString *)page
                                                 eventId:(nullable NSString *)eventId
                                                    arg1:(nullable NSString *)arg1
                                                    arg2:(nullable NSString *)arg2
                                                    arg3:(nullable NSString *)arg3
                                                    argsDict:(nullable NSDictionary *)argsDict;
@end

//
// UTHybridHelper.h
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
NS_ASSUME_NONNULL_BEGIN

@interface UTHybridHelper : NSObject

+(UTHybridHelper *) getInstance;

/** old interface for h5 */
-(void) h5UT:(NSDictionary *) dataDict view:(UIView *) pView viewController:(UIViewController *) pViewController;

/** new interface for h5 (2017)
 *  the requirment of new interface:https://aone.alibaba-inc.com/req/10079562
 */

-(void) h5UT2:(NSDictionary *) dataDict view:(UIView *) pView viewController:(UIViewController *) pViewController;

-(void) setH5Url:(NSString *) url;

@end
NS_ASSUME_NONNULL_END

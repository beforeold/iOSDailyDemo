//
// UTExposureViewProtocol.h
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
#import <UT/UTExposureViewTag.h>
NS_ASSUME_NONNULL_BEGIN
@protocol UTExposureViewProtocol <NSObject>

/**
 view是否需要曝光

 @param view 需要判断的view
 @param url url
 @return 是否需要曝光
 */
- (BOOL)shouldExposeView:(UIView *)view withUrl:(NSString *)url;

/**
 查询当前视图是否需要曝光，无曝光返回null,有曝光请填充相关block,index

 @param view 需要查询的view
 @param url url
 @return tag
 */
- (UTExposureViewTag *)exposureViewTagWithView:(UIView *)view andUrl:(NSString *)url;

/**
 获取附加args数据

 @param view 需要查询的view
 @param url url
 @return args
 */
- (NSDictionary<NSString *, NSString*> *)exposureViewPropertiesWithView:(UIView *) view andUrl:(NSString *)url;

/**
 所有曝光数据清除回调
 */
- (void)onExposureDataCleared;


@end
NS_ASSUME_NONNULL_END

//
// UTExposureViewTag.h
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
@interface UTExposureViewTag : NSObject

//元素的分区，该参数决定该曝光日志和谁一起聚合上传；通常可以填写spm的a.b.c位
@property (nonatomic, strong) NSString *block;
//元素的唯一标识，该参数决定该曝光日志是否已经曝光；通常可以填写spm的a.b.c.d
@property (nonatomic, strong) NSString *viewId;
//是否需要曝光，用来补偿shouldExposure接口判断错误的情况
@property (nonatomic, assign) BOOL notExposure;

@end
NS_ASSUME_NONNULL_END

//
//  LASocializationReportViewController.h
//  LASocialization
//
//  Created by Cheng Ma on 2019/7/9.
//  Copyright © 2019 lazada.com. All rights reserved.
//

@import UIKit;

//#import <LAUIKit/LAUIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LASocializationReportBizType) {
    LASocializationReportBizTypeFeed    = 1,
    LASocializationReportBizTypeComment      = 2
};

@interface LASocializationReportViewController : UIViewController

@property (nonatomic, assign) LASocializationReportBizType bizType;

@property (nonatomic, assign) UInt64 channelObjectId;
@property (nonatomic, assign) UInt64 commentId;
@property (nonatomic, assign) UInt64 replyId;

@property (nonatomic, copy, nullable) void (^reportDidSuccess)(void);

-(instancetype)initWithBizType:(LASocializationReportBizType)bizType;
-(void)presentVC;

@end

NS_ASSUME_NONNULL_END

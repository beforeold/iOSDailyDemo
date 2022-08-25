//
//  LASocializationCommentPublic.h
//  LASocialization
//
//  Created by guobing.sgb on 2018/10/11.
//  Copyright © 2018年 lazada.com. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT NSString * const LASocializationCommentChannelTypeFeed;
FOUNDATION_EXPORT NSString * const LASocializationCommentChannelTypeVideo;

@protocol LASocializationErrorProtocol;
@class LASocializationCommentModel;

typedef void(^LASocializationSendCommentResult)(LASocializationCommentModel *comment, id<LASocializationErrorProtocol> error);
typedef void(^LASocializationCommentCancel)(void);

@interface LASocializationCommentStyle : NSObject

@property(nonatomic, strong) UIColor *backgroundColor;
@property(nonatomic, strong) UIColor *userNameColor;
@property(nonatomic, strong) UIColor *contentColor;
@property(nonatomic, strong) UIColor *replyUserColor;

@property(nonatomic, assign) CGFloat verticalLineWidth;
@property(nonatomic, assign) CGFloat verticalLineBorderRadius;
@property(nonatomic, strong) UIColor *verticalLineColor;

@end

@interface LASocializationCommentParam : NSObject

@property(nonatomic, strong) NSString *channel;
@property(nonatomic, strong) NSString *channelObjectId;

@property(nonatomic, assign) BOOL showKeyboard;
@property(nonatomic, assign) BOOL showInputBar;

@property(nonatomic, strong) LASocializationCommentStyle *commentStyle;

@property(nonatomic, strong) NSString *pageName;

@property(nonatomic, assign) NSInteger pageSize;

+ (instancetype)commentParamWithChannel:(NSString *)channel
                        channelObjectId:(NSString *)channelObjectId
                           showKeyboard:(BOOL)showKeyboard;

@end

@interface LASocializationCommentPublic : NSObject

+ (void)showCommentListWithCommentParam:(LASocializationCommentParam *)commentParam;

@end

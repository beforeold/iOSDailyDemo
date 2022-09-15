//
//  LASocializationCommentInputView.h
//  LASocialization
//
//  Created by guobing.sgb on 2018/11/6.
//  Copyright © 2018年 lazada.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LASocializationCommentDataProtocol, LASocializationErrorProtocol;
@class LASocializationCommentParam, LASocializationCommentModel;

@protocol LASocializationCommentInputViewDelegate <NSObject>

@optional

- (void)sendCommentComplete:(LASocializationCommentModel *)commentResult
              sourceComment:(LASocializationCommentModel *)sourceComment
                      error:(id<LASocializationErrorProtocol>)error;

- (void)didSelectImages:(LASocializationCommentModel *)comment;
- (void)didDismissedInputView;

- (void)didTapChoosePicture:(id)sender;

- (NSDictionary *)trackingArgs;

@end

@interface LASocializationCommentInputView : UIView

@property(nonatomic, weak) id<LASocializationCommentInputViewDelegate> delegate;
//viewcontroller to show uploading toast
@property(nonatomic, weak) UIViewController *vc;

- (instancetype)initWithFrame:(CGRect)frame
                 commentParam:(LASocializationCommentParam *)param;

- (void)resetData;

- (void)setChannelObjectId:(NSString *)channelObjectId;

- (void)replyComment:(LASocializationCommentModel *)comment;

+ (CGFloat)defaultCommentInputBarHeight;

@end

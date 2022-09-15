//
//  LASocializationCommentListView.h
//  LASocialization
//
//  Created by guobing.sgb on 2018/9/18.
//  Copyright © 2018年 lazada.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LASocialization/LASocializationCommentPublic.h>
#import "LASocializationCommentListViewController.h"

@protocol LASocializationErrorProtocol;
@class LASocializationCommentListModel, LASocializationCommentModel, LASocializationCommentParam, LASocializationBaseCell, LASocializationParam;

@protocol LASocializationCommentListViewDelegate <NSObject>

@optional

- (void)loadDataComplete:(LASocializationCommentListModel *)model error:(id<LASocializationErrorProtocol>)error;

- (void)updateCommentCount:(NSInteger)commentCount;

- (void)replyComment:(LASocializationCommentModel *)comment
                cell:(LASocializationBaseCell *)cell;

- (void)willDisplayBackgroundImageView:(UIImageView *)imageView
                              tipLabel:(UILabel *)lbl
                         containerView:(UIView *)containerView;

- (void)showReportView:(id)model
            indexPath:(NSIndexPath *)indexPath;

//- (void)uploadPictures:(NSArray *)params completion:(void(^)(NSDictionary *fileResult, NSError *error))completion;

@end

@interface LASocializationCommentListView : UIView

@property(nonatomic, weak) LASocializationCommentListViewController *vc;
@property(nonatomic, weak) id<LASocializationCommentListViewDelegate> delegate;

/**
 * If you want to customize the appearance of comment list, you must give valid
 * commentParam.
 */
- (instancetype)initWithFrame:(CGRect)frame
                 commentParam:(LASocializationCommentParam *)param;

/**
 * Make sure to set channelObjectId before loadData.
 */
- (void)setChannelObjectId:(NSString *)channelObjectId;

- (void)loadData;

- (BOOL)hasData:(LASocializationParam *)target;

- (void)viewDidAppear;
- (void)viewDidDisAppear;

/**
 * Send comment text.
 *
 * Note: comment text length should be <= 500.
 */
- (void)sendCommentText:(NSString *)text
           replyComment:(LASocializationCommentModel *)replyComment
               complete:(LASocializationSendCommentResult)complete
                 cancel:(LASocializationCommentCancel)cancel;

- (void)scrollToShowCell:(LASocializationBaseCell *)cell
  inputAndKeyboardHeight:(CGFloat)inputAndKeyboardHeight;

/**
 * Reset to max contentOffset, if contentOffset is larger than that after
 * you use scrollToShowCell, else do nothing.
 */
- (void)resetScroll;

- (BOOL)chatEnable;
- (NSString *)getChatLink;
- (void)sendMSGtoStore:(UIViewController *)vc;

@end

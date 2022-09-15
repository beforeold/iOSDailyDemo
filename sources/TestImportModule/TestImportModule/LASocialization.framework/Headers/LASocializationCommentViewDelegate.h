//
//  LASocializationCommentViewDelegate.h
//  LASocialization
//
//  Created by guobing.sgb on 2018/9/27.
//  Copyright © 2018年 lazada.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LASocialization/LASocializationCommentPublic.h>

@protocol LASocializationCommentBaseModel, LASocializationLikeProtocol, LASocializationLinkProtocol;
@class LASocializationCommentBaseCell, LASocializationCommentBaseCollectionCell, LASocializationCommentContent, LASocializationCommentStyle;
@protocol LASocializationCommentViewDelegate <NSObject>

@optional

- (void)replyComment:(id<LASocializationCommentBaseModel>)model;

- (void)replyComment:(id<LASocializationCommentBaseModel>)model cell:(LASocializationCommentBaseCell *)cell;

- (void)replyComment:(id<LASocializationCommentBaseModel>)model
      collectionCell:(LASocializationCommentBaseCollectionCell *)cell;

- (void)viewMoreComments:(id<LASocializationCommentBaseModel>)model;

- (void)didTapCommentImageView:(UIView *)sender             model:(id<LASocializationCommentBaseModel>)model
                     indexPath:(NSIndexPath *)indexPath
                     itemIndex:(NSInteger)index;

- (void)didTapChoosePicture:(id)sender;

/**
 * Add a new comment or reply someone's comment.
 *
 * @param content comment content.
 * @param replyComment nil for new comment.
 * @param complete send comment complete.
 * @param cancel user cancel login.
 */
- (void)sendComment:(LASocializationCommentContent *)content
       replyComment:(id<LASocializationCommentBaseModel>)replyComment
           complete:(LASocializationSendCommentResult)complete
             cancel:(LASocializationCommentCancel)cancel;

- (void)didTapLike:(id<LASocializationLikeProtocol>)sender
             model:(LASocializationCommentModel *)model
         indexPath:(NSIndexPath *)indexPath;

- (void)didTapLike:(id<LASocializationLikeProtocol>)sender
      commentModel:(LASocializationCommentModel *)model
         indexPath:(NSIndexPath *)indexPath;

- (void)openLink:(id<LASocializationLinkProtocol>)link indexPath:(NSIndexPath *)indexPath;

- (void)showReportView:(id)model
             indexPath:(NSIndexPath *)indexPath isReply:(BOOL)isReply;

- (void)didTapMoreOptions:(id)sender
                    model:(LASocializationCommentModel *)model
                indexPath:(NSIndexPath *)indexPath;

- (void)addComment;

- (void)didSelectedImageWithModel:(LASocializationCommentModel *)model;

- (LASocializationCommentStyle *)commentStyle;

- (BOOL)isFirstReply:(LASocializationCommentModel *)model;
- (BOOL)isLastReply:(LASocializationCommentModel *)model;

@end

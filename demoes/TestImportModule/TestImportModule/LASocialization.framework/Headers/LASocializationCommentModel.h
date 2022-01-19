//
//  LASocializationCommentModel.h
//  LASocialization
//
//  Created by guobing.sgb on 2018/9/19.
//  Copyright © 2018年 lazada.com. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <TBJSONModel/TBJSONModel.h>
//#import <AliHAProtocol/AliHAProtocol.h> // fix build error, but don't know why
#import <LASocialization/LASocializationTableViewDataProtocol.h>
#import <LASocialization/LASocializationCommentDataProtocol.h>
#import <LASocialization/LASocializationLinkProtocol.h>

@interface LASocializationCommentContent : NSObject

@property(nonatomic, assign) LASocializationCommentContentType contentType;
/**
 * For LASocializationCommentContentTypeText.
 */
@property(nonatomic, strong) NSString *text;
@property(nonatomic, strong) NSArray *commentImgs;

+ (instancetype)commentContentWithType:(LASocializationCommentContentType)contentType text:(NSString *)text commentImgs:(NSArray *)commentImgs;

@end

@protocol LASocializationCommentBaseModel <LASocializationTableViewCellDataProtocol>
@end

@protocol LASocializationCommentModel <LASocializationCommentBaseModel, LASocializationCommentDataProtocol, LASocializationLinkProtocol>
@end

@interface LASocializationCommentModel : NSObject/*brooked*/ <LASocializationCommentModel>

@property(nonatomic, assign) NSInteger contentType;
@property(nonatomic, strong) NSString *content;
@property(nonatomic, strong) NSString *userName;
@property(nonatomic, assign) UInt64 commentId;
@property(nonatomic, assign) UInt64 replyToId;
@property(nonatomic, assign) UInt64 firstLevelCommentId;
@property(nonatomic, strong) NSString *userAvatar;
@property(nonatomic, assign) LASocializationCommentType commentType;
@property(nonatomic, assign) NSInteger level;
@property(nonatomic, strong) NSArray<LASocializationCommentModel> *subCommentList;
@property(nonatomic, strong) NSString *timestamp;
@property(nonatomic, strong) NSString *lastAuthor;
@property(nonatomic, assign) BOOL like;
@property(nonatomic, assign) UInt64 likeCount;
@property(nonatomic, strong) NSArray *commentImgs;
// For seller comment
@property(nonatomic, strong) NSString *userLabel;
@property(nonatomic, assign) BOOL userNameHighlight;
@property(nonatomic, strong) NSString *link;

@property(nonatomic, assign) BOOL highlighted;

@property(nonatomic, strong) NSString *spmCD;

+ (instancetype)commentWithContent:(LASocializationCommentContent *)content replyComment:(LASocializationCommentModel *)replyComment;

@end

@protocol LASocializationCommentViewMoreModel <LASocializationCommentBaseModel>
@end

@interface LASocializationCommentViewMoreModel : NSObject <LASocializationCommentViewMoreModel>

@property(nonatomic, assign) NSInteger moreCommentsCount;
@property(nonatomic, assign) UInt64 firstLevelCommentId;

@end

@protocol LASocializationCommentSectionModel <LASocializationTableViewSectionDataProtocol>
@end

@interface LASocializationCommentSectionModel : NSObject <LASocializationCommentSectionModel>

@property(nonatomic, strong) NSString *sectionTitle;
@property(nonatomic, strong) NSArray<LASocializationCommentBaseModel> *list;

@end

@class LASocializationPageInfo;

@protocol LASocializationCommentListModel <LASocializationTableViewDataProtocol>

/**
 * Original comment list.
 */
@property(nonatomic, strong) NSArray<LASocializationCommentModel> *commentList;

@property(nonatomic, strong) NSArray<LASocializationCommentSectionModel> *sections;

- (void)setUpModel;

- (void)viewMoreReplies:(id<LASocializationCommentBaseModel>)model;

- (void)bufferComment:(LASocializationCommentModel *)comment;
- (void)addBufferComment;

- (void)addComment:(LASocializationCommentModel *)comment;

- (void)replyComment:(LASocializationCommentModel *)replyComment withComment:(LASocializationCommentModel *)comment;

- (BOOL)isFistReply:(LASocializationCommentModel *)model;
- (BOOL)isLastReply:(LASocializationCommentModel *)model;

@end

@interface LASocializationCommentListModel : NSObject/*brooked*/ <LASocializationCommentListModel>

@property(nonatomic, strong) NSString *channel;
@property(nonatomic, strong) NSString *channelObjectId;
@property(nonatomic, strong) NSString *commentsLandingPageTitle;
@property(nonatomic, assign) NSInteger allCommentCount;
@property(nonatomic, strong) NSString *iosChatLink;

/**
 * Original comment list.
 */
@property(nonatomic, strong) NSArray<LASocializationCommentModel> *commentList;

@property(nonatomic, strong) LASocializationPageInfo *pageInfo;

@property(nonatomic, strong) NSArray<LASocializationCommentSectionModel> *sections;

- (void)setUpModel;
- (void)appendData:(LASocializationCommentListModel *)model;

- (void)viewMoreReplies:(id<LASocializationCommentBaseModel>)model;

- (void)bufferComment:(LASocializationCommentModel *)comment;
- (void)addBufferComment;

- (void)addComment:(LASocializationCommentModel *)comment;

- (void)replyComment:(LASocializationCommentModel *)replyComment withComment:(LASocializationCommentModel *)comment;

- (BOOL)isFistReply:(LASocializationCommentModel *)model;
- (BOOL)isLastReply:(LASocializationCommentModel *)model;

@end

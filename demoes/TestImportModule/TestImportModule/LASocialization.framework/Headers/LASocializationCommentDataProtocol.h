//
//  LASocializationCommentDataProtocol.h
//  LASocialization
//
//  Created by guobing.sgb on 2018/11/6.
//  Copyright © 2018年 lazada.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LASocializationCommentType) {
    LASocializationCommentTypeBuyer     = 1,
    LASocializationCommentTypeSeller    = 2
};

typedef NS_ENUM(NSInteger, LASocializationCommentContentType) {
    LASocializationCommentContentTypeText   = 1
};

@protocol LASocializationCommentDataProtocol <NSObject>

@property(nonatomic, strong) NSString *content;
@property(nonatomic, strong) NSString *userName;
@property(nonatomic, strong) NSString *userAvatar;

@optional

@property(nonatomic, assign) NSInteger contentType;
@property(nonatomic, assign) UInt64 commentId;
@property(nonatomic, assign) UInt64 replyToId;
@property(nonatomic, assign) UInt64 firstLevelCommentId;
@property(nonatomic, assign) LASocializationCommentType commentType;
@property(nonatomic, assign) NSInteger level;
@property(nonatomic, strong) NSArray<LASocializationCommentDataProtocol> *subCommentList;
@property(nonatomic, strong) NSString *timestamp;
@property(nonatomic, strong) NSString *lastAuthor;

@property(nonatomic, strong) NSArray *commentImgs;

@end

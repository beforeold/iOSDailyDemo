//
//  LASocializationLikeHelper.h
//  LASocialization
//
//  Created by guobing.sgb on 2018/11/15.
//  Copyright © 2018年 lazada.com. All rights reserved.
//

#import <LASocialization/LASocializationActionHelperBase.h>

@protocol LASocializationLikeProtocol;
@class LASocializationLikeTarget, LASocializationCommentModel;

@interface LASocializationLikeHelper : LASocializationActionHelperBase

@property(nonatomic, strong) NSDictionary *args;

- (instancetype)initWithPageName:(NSString *)pageName
                         channel:(NSString *)channel
                 channelObjectId:(NSString *)channelObjectId;

- (void)likeComment:(LASocializationCommentModel *)model
             sender:(id<LASocializationLikeProtocol>)sender;

@end

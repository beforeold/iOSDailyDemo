//
//  LASocializationLikeTarget.h
//  LASocialization
//
//  Created by guobing.sgb on 2018/11/15.
//  Copyright © 2018年 lazada.com. All rights reserved.
//

#import <LASocialization/LASocializationConstants.h>

@interface LASocializationLikeTarget : LASocializationParam

@property(nonatomic, assign) UInt64 commentId;
@property(nonatomic, assign) UInt64 replyId;

@property(nonatomic, assign) BOOL like;

+ (instancetype)targetWithChannel:(LASocializationChannelType *)channel
                  channelObjectId:(NSString *)channelObjectId;

@end

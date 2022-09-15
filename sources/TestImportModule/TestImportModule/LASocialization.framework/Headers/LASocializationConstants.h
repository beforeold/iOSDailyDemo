//
//  LASocializationConstants.h
//  LASocialization
//
//  Created by guobing.sgb on 2018/9/18.
//  Copyright © 2018年 lazada.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSString LASocializationChannelType;

FOUNDATION_EXPORT LASocializationChannelType * const LASocializationChannelTypeFeed;
FOUNDATION_EXPORT LASocializationChannelType * const LASocializationChannelTypeVideo;

@interface LASocializationParam : NSObject

@property(nonatomic, strong) LASocializationChannelType *channel;
@property(nonatomic, strong) NSString *channelObjectId;

@property(nonatomic, strong) NSString *pageName;

- (instancetype)initWithChannel:(LASocializationChannelType *)channel
                channelObjectId:(NSString *)channelObjectId;

@end

@interface LASocializationConstants : NSObject

@end

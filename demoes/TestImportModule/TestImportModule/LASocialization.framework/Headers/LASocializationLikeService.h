//
//  LASocializationLikeService.h
//  LASocialization
//
//  Created by guobing.sgb on 2018/11/15.
//  Copyright © 2018年 lazada.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LASocializationErrorProtocol;
@class LASocializationLikeTarget;

typedef void(^LASocializationLikeResult)(BOOL like, NSInteger likeCount, id<LASocializationErrorProtocol> error);
typedef void(^LASocializationLikeCancel)(void);

@interface LASocializationLikeService : NSObject

+ (instancetype)sharedService;

- (void)likeTarget:(nonnull LASocializationLikeTarget *)target
          complete:(LASocializationLikeResult)complete
            cancel:(LASocializationLikeCancel)cancel;

@end

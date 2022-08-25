//
//  LASocializationCommentBaseCell.h
//  LASocialization
//
//  Created by guobing.sgb on 2018/9/28.
//  Copyright © 2018年 lazada.com. All rights reserved.
//

#import <LASocialization/LASocializationBaseCell.h>

@protocol LASocializationCommentViewDelegate;

@interface LASocializationCommentBaseCell : LASocializationBaseCell

@property(nonatomic, weak) id<LASocializationCommentViewDelegate> delegate;

@end

@interface LASocializationCommentBaseCollectionCell : LASocializationBaseCollectionCell

@property(nonatomic, weak) id<LASocializationCommentViewDelegate> delegate;

@end

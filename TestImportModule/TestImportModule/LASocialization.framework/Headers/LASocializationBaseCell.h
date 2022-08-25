//
//  LASocializationBaseCell.h
//  LASocialization
//
//  Created by guobing.sgb on 2018/9/18.
//  Copyright © 2018年 taobao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LASocializationCellProtocol <NSObject>

@optional

- (void)cellWasTapped;

@end

@interface LASocializationBaseCell : UITableViewCell <LASocializationCellProtocol>

@property(nonatomic, copy) void (^deleteAction)(NSIndexPath *indexPath);

@property(nonatomic, copy) void (^cellTappedAction)(NSIndexPath *indexPath);

@property(nonatomic, copy, readonly) NSIndexPath *indexPath;

@property(nonatomic, weak) UITableView *tableView;

+ (CGFloat)cellHeight:(id)model;

- (void)bindData:(id)model;

- (CGRect)scrollToShowFrameOnWnd;

@end

@interface LASocializationBaseCollectionCell : UICollectionViewCell

@property(nonatomic, weak) UICollectionView *collectionView;
@property(nonatomic, copy, readonly) NSIndexPath *indexPath;

+ (CGSize)cellSizeWithModel:(id)model;

- (void)bindData:(id)model;

- (CGRect)scrollToShowFrameOnWnd;

@end

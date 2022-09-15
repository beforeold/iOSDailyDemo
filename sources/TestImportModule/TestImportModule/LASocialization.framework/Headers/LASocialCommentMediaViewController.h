//
//  LASocialCommentMediaViewController.h
//  LASocialization
//
//  Created by Cheng Ma on 2019/11/4.
//  Copyright © 2019 lazada.com. All rights reserved.
//

// #import <LAUIKit/LAUIKit.h>
@import UIKit;
#import "LASocializationCommentModel.h"
#import "LASocialImageGalleryViewDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface LASocialCommentMediaViewController : UIViewController

@property(nonatomic, weak) id<LASocialImageGalleryViewDelegate> delegate;
@property(nonatomic, assign) NSUInteger currentIndex;
@property(nonatomic, assign) CGRect rcInScreen;

- (instancetype)initWithModel:(id<LASocializationCommentBaseModel>)model currentIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END

//
//  RegstierFactory.h
//  TestCellRegister
//
//  Created by 席萍萍Brook.dinglan on 2021/12/31.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyCollectionView : UICollectionView

@end

@interface UICollectionView (RegstierFactory)

- (UICollectionViewCell *)getRegisterFromIndexPath:(NSIndexPath *)indexPath
                                           ofArray:(NSArray *)array
                                              item:(id)item;

@end

NS_ASSUME_NONNULL_END

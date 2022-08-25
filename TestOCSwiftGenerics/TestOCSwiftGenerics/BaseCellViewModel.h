//
//  BaseCellViewModel.h
//  TestOCSwiftGenerics
//
//  Created by dinglan on 2021/5/20.
//

#import "BaseSectionViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseCellViewModel<__covariant ModelType: BaseModel *> : BaseSectionViewModel<ModelType>

@end

NS_ASSUME_NONNULL_END

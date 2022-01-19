//
//  SubViewModel.h
//  TestOCSwiftGenerics
//
//  Created by dinglan on 2021/5/20.
//

#import "BaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseSectionViewModel<__covariant ModelType: BaseModel *> : BaseViewModel<ModelType>

@end

NS_ASSUME_NONNULL_END

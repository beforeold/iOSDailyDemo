//
//  ViewModel.h
//  TestOCSwiftGenerics
//
//  Created by dinglan on 2021/5/20.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewModel  <__covariant ModelType: BaseModel *>: NSObject

@property (nonatomic, strong) ModelType model;

@end

NS_ASSUME_NONNULL_END

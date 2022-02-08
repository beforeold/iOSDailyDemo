//
//  MLCParseResult.h
//  TestSwiftOCArrayBridinging
//
//  Created by BrookXy on 2022/2/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MLCComponent;

@interface MLCParseResult : NSObject

@property (nonatomic, strong) NSMutableArray <MLCComponent *> *mutableArray;

@property (nonatomic, copy) NSArray <MLCComponent *> *immutableArray;

@property (nonatomic, copy) NSString *name;


@end

NS_ASSUME_NONNULL_END

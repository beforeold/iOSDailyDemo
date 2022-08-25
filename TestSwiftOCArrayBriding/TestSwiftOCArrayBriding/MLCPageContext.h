//
//  MLCPageContext.h
//  TestSwiftOCArrayBriding
//
//  Created by BrookXy on 2022/2/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MLCParseResult;

@interface MLCPageContext : NSObject

@property (nonatomic, strong) MLCParseResult *parseResult;

@property (nonatomic, copy) NSString *name;

+ (NSString *)testNilString;

+ (NSNumber *)testNilNumber;

@end

NS_ASSUME_NONNULL_END

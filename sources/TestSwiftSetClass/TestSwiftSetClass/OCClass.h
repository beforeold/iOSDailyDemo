//
//  OCClass.h
//  TestSwiftSetClass
//
//  Created by BrookXy on 2022/1/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCClass : NSObject

+ (instancetype)createInstance;

+ (BOOL)isTrue;

+ (BOOL)oc_isKindOfClass:(Class)classB object:(id)object;

+ (Class)getClassOfObject:(id)object;

@end

NS_ASSUME_NONNULL_END

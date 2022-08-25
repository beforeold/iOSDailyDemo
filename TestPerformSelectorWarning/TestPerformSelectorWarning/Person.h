//
//  Person.h
//  TestPerformSelectorWarning
//
//  Created by BrookXy on 2022/1/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject

+ (void)playClass;

- (BOOL)playInstanceWithObject:(id)object;

@end

NS_ASSUME_NONNULL_END

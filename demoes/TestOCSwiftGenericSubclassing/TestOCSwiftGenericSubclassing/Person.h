//
//  Person.h
//  TestOCSwiftGenericSubclassing
//
//  Created by 席萍萍Brook.dinglan on 2021/12/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN



@interface Person<T> : NSObject

- (NSString *)getName;

@end

NS_ASSUME_NONNULL_END

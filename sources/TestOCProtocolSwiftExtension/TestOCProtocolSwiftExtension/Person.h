//
//  Person.h
//  TestOCProtocolSwiftExtension
//
//  Created by 席萍萍Brook.dinglan on 2021/11/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PersonProtocol <NSObject>

- (void)play;

@end

@interface Person : NSObject <PersonProtocol>

@end

NS_ASSUME_NONNULL_END

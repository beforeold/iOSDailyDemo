//
//  SomeManager.h
//  TestSwiftImplementOCProtocol
//
//  Created by 席萍萍Brook.dinglan on 2021/11/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol OCProtocol <NSObject>

- (void)foo;

- (instancetype)initWithName:(NSString *)name;

@end


@interface SomeManager : NSObject

+ (void)run;

@end

NS_ASSUME_NONNULL_END

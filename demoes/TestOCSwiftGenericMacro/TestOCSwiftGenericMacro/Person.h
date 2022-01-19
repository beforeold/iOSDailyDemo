//
//  Person.h
//  TestOCSwiftGenericMacro
//
//  Created by 席萍萍Brook.dinglan on 2021/12/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Animal : NSObject

@end


#define metamacro_concat_(A, B) A ## B

#define THE_ANIMAL metamacro_concat_(Ani, mal)

#define AnimalRef metamacro_concat_(Animal , *)

#define HIDE :THE_ANIMAL*

@interface Person <P HIDE> : THE_ANIMAL

- (P)getPet;

@end

NS_ASSUME_NONNULL_END

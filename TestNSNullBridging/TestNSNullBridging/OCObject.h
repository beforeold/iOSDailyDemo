//
//  OCObject.h
//  TestNSNullBridging
//
//  Created by BrookXy on 2022/4/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCObject : NSObject

- (void)playWithArgs:(NSArray *)args;

- (void)subclass_playWithArgs:(NSArray *)args;

@end

NS_ASSUME_NONNULL_END

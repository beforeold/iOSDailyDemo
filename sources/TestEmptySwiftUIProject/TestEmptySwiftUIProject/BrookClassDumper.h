//
//  BrookClassDumper.h
//  iosApp
//
//  Created by dinglan on 2021/1/21.
//  Copyright © 2021 orgName. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BrookClassDumper : NSObject

+ (NSArray <NSString *> *)findViewControllerClassNames;

@end

NS_ASSUME_NONNULL_END

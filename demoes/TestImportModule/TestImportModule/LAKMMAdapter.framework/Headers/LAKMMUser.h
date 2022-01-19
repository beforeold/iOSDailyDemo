//
//  LAKMMUser.h
//  LAKMMAdapter
//
//  Created by dinglan on 2021/3/1.
//

#import <Foundation/Foundation.h>

@class LAKMMUserModel;

NS_ASSUME_NONNULL_BEGIN

@interface LAKMMUser : NSObject

+ (nullable LAKMMUserModel *)currentUser;

@end

NS_ASSUME_NONNULL_END

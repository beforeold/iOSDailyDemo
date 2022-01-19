//
//  LAKMMUserModel.h
//  LAKMMAdapter
//
//  Created by dinglan on 2021/3/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LAKMMUserModel : NSObject

- (instancetype)initWithUserId:(NSString *)userId
                          name:(NSString *)name
                        avatar:(NSString *)avatar;

@property (nonatomic, copy, readonly) NSString *userId;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *avatar;

@end

NS_ASSUME_NONNULL_END

//
//  Person.h
//  TestOCProtocolSwift
//
//  Created by 席萍萍Brook.dinglan on 2021/10/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FileObject : NSObject

@end




@protocol TestProtocol <NSObject>

@optional
@property (nonatomic, weak) FileObject *file;
- (FileObject *)file;
- (void)setFile:(FileObject *)file;

@end


@interface Person : NSObject

@end

NS_ASSUME_NONNULL_END

//
//  ImageDumper.h
//  TestImageDump
//
//  Created by beforeold on 2022/10/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class UIImage;

@interface ImageDumper : NSObject

- (UIImage *)dump:(UIImage *)originImage;

@end

NS_ASSUME_NONNULL_END

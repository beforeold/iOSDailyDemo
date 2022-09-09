//
//  Driver.h
//  Test_OC_MRC
//
//  Created by Brook on 2019/11/27.
//  Copyright © 2019 br. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef struct XPSize {
    int width, height;
} XPSize;

@class Car;
@interface Driver : NSObject

@property Car *carCar;// 非 ARC 默认 assign，还有 retain，copy 可选

@property XPSize size;

- (void)setCar:(Car *)car;
- (Car *)car;

@end

NS_ASSUME_NONNULL_END

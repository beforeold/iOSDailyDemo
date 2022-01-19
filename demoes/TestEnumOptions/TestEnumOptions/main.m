//
//  main.m
//  TestEnumOptions
//
//  Created by 席萍萍Brook.dinglan on 2021/12/9.
//

#import <Foundation/Foundation.h>
#import "TestEnumOptions-Swift.h"

typedef NS_OPTIONS(NSUInteger, LAUIViewControllerVisibleState) {
    LAUIViewControllerInit = 0,
    LAUIViewControllerViewDidLoad   = 1 << 1,   // 触发了 viewDidLoad
    LAUIViewControllerWillAppear    = 1 << 2,   // 触发了 viewWillAppear

    LAUIViewControllerDidAppear     = 1 << 3,   // 触发了 viewDidAppear
    LAUIViewControllerWillDisappear = 1 << 4,   // 触发了 viewWillDisappear
    LAUIViewControllerDidDisappear  = 1 << 5,   // 触发了 viewDidDisappear
    
    LAUIViewControllerVisible       = LAUIViewControllerWillAppear | LAUIViewControllerDidAppear,// 表示是否处于可视范围
};

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        __auto_type one = LAUIViewControllerDidDisappear;
        __auto_type set = one | LAUIViewControllerViewDidLoad;
        __auto_type ret = set & one;
        __auto_type ret2 = one & set;
        NSLog(@"ret: %zd, ret2: %zd", ret, ret2);
        
        [SwiftTest test];
    }
    return 0;
}

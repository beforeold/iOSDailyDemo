//
//  SomeProtocol.h
//  TestOCEumForSwift
//
//  Created by 席萍萍Brook.dinglan on 2021/12/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_OPTIONS(NSUInteger, LAUIViewControllerVisibleState) {
    LAUIViewControllerInit        = 0,   // 初始化完成但尚未触发 viewDidLoad
    LAUIViewControllerUnknow        = 1 << 0,   // 初始化完成但尚未触发 viewDidLoad
    LAUIViewControllerViewDidLoad   = 1 << 1,   // 触发了 viewDidLoad
    LAUIViewControllerWillAppear    = 1 << 2,   // 触发了 viewWillAppear
    LAUIViewControllerDidAppear     = 1 << 3,   // 触发了 viewDidAppear
    LAUIViewControllerWillDisappear = 1 << 4,   // 触发了 viewWillDisappear
    LAUIViewControllerDidDisappear  = 1 << 5,   // 触发了 viewDidDisappear
    // 无法 get 到 ,表示是否处于可视范围, 可以通过 visibleState & LAUIViewControllerVisible 判断 vc 是否可视
    LAUIViewControllerVisible       = LAUIViewControllerWillAppear | LAUIViewControllerDidAppear,
};


@protocol SomeProtocol <NSObject>

@end

NS_ASSUME_NONNULL_END

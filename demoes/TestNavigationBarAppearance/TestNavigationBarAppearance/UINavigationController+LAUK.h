//
//  UINavigationController+LAUK.h
//  TestNavigationBarAppearance
//
//  Created by 席萍萍Brook.dinglan on 2021/10/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (LAUK)

- (void)lauk_displayCustomNavigationBarFromColor:(UIColor *)color1
                                         toColor:(UIColor *)color2
                                       titleFont:(UIFont *)tFont
                                      titleColor:(UIColor *)tColor
                                  statusBarStyle:(UIStatusBarStyle)style;

- (void)_lauk_customNavigationBarWithBackgroundImage:(UIImage *)backgroundImage
                                     titleAttributes:(NSDictionary *)titleAttributes
                                           tintColor:(UIColor *)tintColor
                                            barStyle:(UIBarStyle)barStyle
                                        barTintColor:(UIColor *)barTintColor
                                      statusBarStyle:(UIStatusBarStyle)statusBarStyle;

@end

NS_ASSUME_NONNULL_END

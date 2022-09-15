//
//  UINavigationController+LAUK.m
//  TestNavigationBarAppearance
//
//  Created by 席萍萍Brook.dinglan on 2021/10/14.
//

#import "UINavigationController+LAUK.h"

@implementation UINavigationController (LAUK)


- (void)lauk_displayCustomNavigationBarFromColor:(UIColor *)color1
                                         toColor:(UIColor *)color2
                                       titleFont:(UIFont *)tFont
                                      titleColor:(UIColor *)tColor
                                  statusBarStyle:(UIStatusBarStyle)style {
    
    UIImage *backgroundImage;
    // Update the navigationbar with custom color
    if ([color1 isKindOfClass:[UIColor class]] && [color2 isKindOfClass:[UIColor class]]) {
        backgroundImage = [self lauk_imageWithColor:color1];
    } else {
        backgroundImage = [self lauk_imageWithColor:UIColor.whiteColor];
    }
    
    __auto_type titleAttributes = @{
        NSFontAttributeName : tFont ?: [UIFont systemFontOfSize:15],
        NSForegroundColorAttributeName : tColor ?: UIColor.blackColor,
    };
    
    [self _lauk_customNavigationBarWithBackgroundImage:backgroundImage
                                       titleAttributes:titleAttributes
                                             tintColor:UIColor.whiteColor
                                              barStyle:UIBarStyleDefault
                                          barTintColor:style == UIStatusBarStyleLightContent ? UIColor.whiteColor : UIColor.blackColor
                                        statusBarStyle:style];
}


- (void)_lauk_customNavigationBarWithBackgroundImage:(UIImage *)backgroundImage
                                     titleAttributes:(NSDictionary *)titleAttributes
                                           tintColor:(UIColor *)tintColor
                                            barStyle:(UIBarStyle)barStyle
                                        barTintColor:(UIColor *)barTintColor
                                      statusBarStyle:(UIStatusBarStyle)statusBarStyle
{
    if(!self.navigationBar.hidden)
    {
        if (@available(iOS 13.0, *)) {
            __auto_type appearance = [[UINavigationBarAppearance alloc] init];
            [appearance configureWithOpaqueBackground];
            appearance.backgroundImage = backgroundImage;
            appearance.titleTextAttributes = titleAttributes;
            appearance.backgroundColor = barTintColor;
            self.navigationBar.standardAppearance = appearance;
            self.navigationBar.scrollEdgeAppearance = appearance;
            
            
            [self.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
        } else {

        }
        [self.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
        self.navigationBar.titleTextAttributes = titleAttributes;
        self.navigationBar.tintColor = tintColor;
        self.navigationBar.barStyle = barStyle;
        self.navigationBar.barTintColor = barTintColor;
    }
    [UIApplication sharedApplication].statusBarStyle = statusBarStyle;
}


- (UIImage *)lauk_imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end

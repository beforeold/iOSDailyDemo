//
//  ViewController.m
//  TestImageDump
//
//  Created by beforeold on 2022/10/21.
//

#import "ViewController.h"

@import CoreGraphics;
@import Vision;

@interface ViewController ()

@end

@implementation UIImage (image_color)

/// ————————————————
/// 版权声明：本文为CSDN博主「shenyiyangnb」的原创文章，遵循CC 4.0 /// BY-SA版权协议，转载请附上原文出处链接及本声明。
/// 原文链接：https://blog.csdn.net/shenyiyangnb/article/details/80912752

- (UIImage *)colorizeImage:(UIImage *)baseImage
       withBackgroundColor:(UIColor *)theColor {
    
    UIGraphicsBeginImageContext(baseImage.size);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGRect area = CGRectMake(0, 0, baseImage.size.width, baseImage.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSaveGState(ctx);
    
    [theColor set];
    
    CGContextFillRect(ctx, area);
    
    CGContextRestoreGState(ctx);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextDrawImage(ctx, area, baseImage.CGImage); //改变背景
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __auto_type image = [UIImage imageNamed:@"brook2"];
    NSLog(@"all done");
}


@end

//
//  ImageDumper.m
//  TestImageDump
//
//  Created by beforeold on 2022/10/21.
//

#import "ImageDumper.h"

@import UIKit;
@import Vision;

@implementation ImageDumper

/// 作者：爱钓鱼的猫
/// 链接：https://juejin.cn/post/7041139493662883854
/// 来源：稀土掘金
/// 著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
- (UIImage *)dump:(UIImage *)originImage {
    CIImage *ciOriginImg = [CIImage imageWithCGImage:originImage.CGImage];//原始图片
    
    __auto_type imageHandler = [[VNImageRequestHandler alloc] initWithCIImage:ciOriginImg
                                                                      options:nil];
    __auto_type attensionRequest = [[VNGenerateObjectnessBasedSaliencyImageRequest alloc] init];//基于物体的显著性区域检测请求
    
    NSError *err = nil;
    BOOL haveAttension = [imageHandler performRequests:@[attensionRequest] error:&err];//有物品
    // 有物品
    if (haveAttension) {
        if (attensionRequest.results && [attensionRequest.results count] > 0) {
            VNSaliencyImageObservation *observation = [attensionRequest.results firstObject];
            // 获取显著区域热力图，接下来对该图进行边缘检测
            return [self heatMapProcess:observation.pixelBuffer
                       catOrigin:ciOriginImg];
        }
    }
    
    return nil;
}

- (UIImage *)heatMapProcess:(CVPixelBufferRef)hotRef
             catOrigin:(CIImage *)catOrigin {
    CIImage *heatImage = [CIImage imageWithCVPixelBuffer:hotRef];
    VNDetectContoursRequest *contourRequest = [[VNDetectContoursRequest alloc] init];
    contourRequest.revision = VNDetectContourRequestRevision1;
    contourRequest.contrastAdjustment = 1.0;
    contourRequest.detectDarkOnLight = NO;
    contourRequest.maximumImageDimension = 512;
    VNImageRequestHandler *handler = [[VNImageRequestHandler alloc] initWithCIImage:heatImage options:nil];
    NSError *err = nil;
    
    BOOL result = [handler performRequests:@[contourRequest] error:&err];
    if (result) {
        VNContoursObservation *contoursObv = [contourRequest.results firstObject];
        CIContext *cxt = [[CIContext alloc] initWithOptions:nil];
        CGImageRef origin = [cxt createCGImage:catOrigin
                                      fromRect:catOrigin.extent];
        //抠图
        UIImage *clipImage = [self drawContourWith:contoursObv
                                         withCgImg:nil
                                         originImg:origin];
        return clipImage;
    }
    
    return nil;
}


- (UIImage *)drawContourWith:(VNContoursObservation *)contourObv
                   withCgImg:(CGImageRef)img
                   originImg:(CGImageRef)origin {
    CGSize size = CGSizeMake(CGImageGetWidth(origin), CGImageGetHeight(origin));
    UIImageView *originImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    originImgV.image = [UIImage imageWithCGImage:origin];

    CAShapeLayer *layer = [CAShapeLayer layer];
    CGAffineTransform flipMatrix = CGAffineTransformMake(1, 0, 0, -1, 0, size.height);//坐标转换为底部为（0， 0）
    CGAffineTransform scaleTranform = CGAffineTransformScale(flipMatrix, size.width, size.height); //对path 进行按图尺寸放大
    CGPathRef scaedPath = CGPathCreateCopyByTransformingPath(contourObv.normalizedPath, &scaleTranform);//对归一化的path进行变换
    layer.path = scaedPath;
    [originImgV.layer setMask:layer];
    
    UIGraphicsBeginImageContext(originImgV.bounds.size);
    [originImgV.layer renderInContext:UIGraphicsGetCurrentContext()];

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // 对于扣出来的主要内容进行截取
    // 原数据放大的范围是ui的
    CGAffineTransform originScale = CGAffineTransformMakeScale(size.width, size.height);
    CGPathRef originScalePath = CGPathCreateCopyByTransformingPath(contourObv.normalizedPath, &originScale);//归一化的path进行还原，并拿到在图中位置的框
    CGRect targetReact = CGPathGetBoundingBox(originScalePath);
    CIImage *getBoundImage = [[CIImage alloc] initWithImage:image];
    CIImage *targetBoundImg = [getBoundImage imageByCroppingToRect:targetReact];//截取范围的图片
    
    return [UIImage imageWithCIImage:targetBoundImg];
}


@end

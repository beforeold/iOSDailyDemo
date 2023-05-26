//
//  AMAnimatedNumber.h
//  TestNumberAnimation
//
//  Created by Brook_Mobius on 5/26/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger, AMAnimateNumberDirection)
{
    AMAnimateNumberDirectionUp = 0,
    AMAnimateNumberDirectionDown
};

typedef NS_ENUM(NSInteger, AMAnimateNumberAlign)
{
    AMAnimateNumberAlignLeft = 0,
    AMAnimateNumberAlignCenter,
    AMAnimateNumberAlignRight
};

@interface AMAnimatedNumber : UIView

@property (nonatomic, strong) UIColor *textColor; // Label text color, default text color is black color.
@property (nonatomic, strong) UIFont *textFont; // Label text font, default text font is [UIFont systemFontOfSize:17.f].


/**
 *  Set numbers with default direction type AMAnimateNumberDirectionUp.
 *
 *  @param numbers  numbers string.
 *  @param animated animation.
 */
- (void)setNumbers:(NSString *)numbers animated:(BOOL)animated;

/**
 *  Set numbers.
 *
 *  @param numbers   numbers string.
 *  @param animated  animation.
 *  @param direction direction type AMAnimateNumberDirectionUp or AMAnimateNumberDirectionDown.
 */
- (void)setNumbers:(NSString *)numbers animated:(BOOL)animated direction:(AMAnimateNumberDirection)direction;

- (void)setAlignment:(AMAnimateNumberAlign)alignment;

@end

NS_ASSUME_NONNULL_END

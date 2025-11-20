#import "BlurEffectProvider.h"

@implementation BlurEffectProvider

+ (UIVisualEffect *)effectForStyleValue:(NSInteger)value {
  UIBlurEffectStyle style = value;
  return [UIBlurEffect effectWithStyle:style];
}

@end

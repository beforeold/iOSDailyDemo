#import "DYStringFormatter.h"

@implementation DYStringFormatter

+ (NSString *)format:(NSInteger)value {
  __auto_type string = [[NSMutableAttributedString alloc] init];
  __auto_type format = [[NSAttributedString alloc] initWithString:@"%d"];
  [string appendLocalizedFormat:format, value];

  return [string string];
}

@end

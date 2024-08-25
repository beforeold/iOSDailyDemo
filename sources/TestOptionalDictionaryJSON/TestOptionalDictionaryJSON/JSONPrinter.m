#import "JSONPrinter.h"

@implementation JSONPrinter

+ (void)printDictionary:(NSDictionary *)dict {
  // print value for key `string
  NSString *string = dict[@"string"];
  if (string == nil) {
    NSLog(@"string value: is nil");
  } else {
    NSLog(@"string value: %@, class: %@", string, string.class);
  }
}

@end

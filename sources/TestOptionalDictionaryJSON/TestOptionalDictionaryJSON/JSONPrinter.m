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

+ (void)printObject:(id)object {
  NSLog(@"object: %@, class: %@", object, [object class]);
}

@end

#import "NSObject+Object.h"

@implementation NSObject (Object)

+ (void)inputOptions:(VLCMediaParsingOptions)options {
  NSLog(@"options: %d", options);
}

@end

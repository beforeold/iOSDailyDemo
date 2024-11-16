#import "Person.h"

@implementation Person

- (NSArray<NSString *> *)getArray {
  return @[@"ok"];
}

- (NSMutableArray<NSString *> *)getMutableArray {
  return [[self getArray] mutableCopy];
}
- (NSArray<NSString *> *)array {
  return @[@"ok"];
}

- (NSMutableArray<NSString *> *)mutableArray {
  return [self.array mutableCopy];
}

@end

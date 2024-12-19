#import "MYPerson.h"

// MYPerson.kt

@implementation MYPerson

- (NSArray<NSString *> *)requestTasks:(int)value {
  self.name = [NSString stringWithFormat:@"%ld", (long)value];

  return @[];
}

- (void)updateName:(NSString *)name {
  self.name = name;
}

@end

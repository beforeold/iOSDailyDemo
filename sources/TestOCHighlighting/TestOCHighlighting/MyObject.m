#import "MyObject.h"
#import <OSLog/OSLog.h>

@implementation MyObject

- (void)foo {
  NSLog(@"hello objective-c");
  // print("");

  printf("cccc \n");

  [self oslog];
}

- (void)callBlock:(void (^)(void))block {
  block();
}

- (void)oslog {
    if (@available(iOS 14.0, *)) {
        os_log_t customLog = os_log_create("com.yourapp.identifier", "MyObject");
        os_log(customLog, "Logging with os_log from MyObject");
    } else {
        NSLog(@"OSLog is not available. Using NSLog instead.");
    }
}

@end

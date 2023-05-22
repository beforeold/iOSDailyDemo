//
//  NSBundle+BBDebugAppVersion.m
//  TestAppVersionSwizzle
//
//  Created by Brook_Mobius on 5/22/23.
//

#if DEBUG

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

static void swizzle(Class class, SEL originalSelector, SEL swizzledSelector) {
  Method originalMethod = class_getInstanceMethod(class, originalSelector);
  Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);

  // When swizzling a class method, use the following:
  // Method originalMethod = class_getClassMethod(class, originalSelector);
  // Method swizzledMethod = class_getClassMethod(class, swizzledSelector);

  IMP originalImp = method_getImplementation(originalMethod);
  IMP swizzledImp = method_getImplementation(swizzledMethod);

  class_replaceMethod(class,
          swizzledSelector,
          originalImp,
          method_getTypeEncoding(originalMethod));
  
  class_replaceMethod(class,
          originalSelector,
          swizzledImp,
          method_getTypeEncoding(swizzledMethod));
}

static NSDictionary<NSString *, id> *mutateInfoDictionay(NSDictionary *dictionary, NSBundle *bundle) {
  if (bundle != NSBundle.mainBundle) {
    return dictionary;
  }
  
  NSMutableDictionary *infoDictionary = (NSMutableDictionary *)dictionary;
  infoDictionary[@"CFBundleShortVersionString"] = @"1.00.00";
  infoDictionary[@"CFBundleVersion"] = @"1";
  return infoDictionary;
}

@implementation NSBundle (BBDebugAppVersion)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      swizzle([self class], @selector(infoDictionary), @selector(bb_infoDictionary));
      swizzle([self class], @selector(localizedInfoDictionary), @selector(bb_localizedInfoDictionary));
    });
}

#pragma mark - Method Swizzling

- (NSDictionary<NSString *,id> *)bb_infoDictionary {
  __auto_type dictionary = self.bb_infoDictionary;
  return mutateInfoDictionay(dictionary, self);
}

- (NSDictionary<NSString *,id> *)bb_localizedInfoDictionary {
  __auto_type dictionary = self.bb_localizedInfoDictionary;
  return mutateInfoDictionay(dictionary, self);
}

@end

#endif

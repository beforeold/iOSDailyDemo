//
//  ViewController.m
//  TestSecurity
//
//  Created by Brook_Mobius on 2023/2/15.
//

#import "ViewController.h"

@import Security;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  NSString *base64Str = @"BA5ew+DSp6rzHSPcpp+y46Ram0Fu5zg0LqZ1LGCa5LS/DvRTJoeFAKw3Di8VyVovvwn2V3X0aHYJEZ9/CH/e6QQAHrQvJoVelSXxodEyC7N4Q9o7+kzFdW+8thCh7RP/5Bpp2n8AAABhAAAAAAAAAA==";
  NSData *base64Data = [[NSData alloc] initWithBase64EncodedString:base64Str options:NSDataBase64DecodingIgnoreUnknownCharacters];
  
  CFErrorRef error;
  NSDictionary *options = @{};
  SecKeyRef key = SecKeyCreateWithData(
                                       (__bridge CFDataRef) base64Data,
                                       (__bridge CFDictionaryRef) options,
                                       &error);
  NSLog(@"key %p, error: %@", key, error);
}
@end

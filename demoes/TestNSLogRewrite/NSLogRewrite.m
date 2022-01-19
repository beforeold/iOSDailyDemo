//
//  NSLogRewrite.m
//  TestNSLogRewrite
//
//  Created by BrookXy on 2022/1/12.
//

#import "NSLogRewrite.h"

@implementation NSLogRewrite

@end

#ifdef SHUT_DOWN_ALL_LOGS
void NSLog (NSString *format, ...) {}
void NSLogv (NSString *format, va_list args) { }
int printf (const char *format, ...) { return 0; }
#endif

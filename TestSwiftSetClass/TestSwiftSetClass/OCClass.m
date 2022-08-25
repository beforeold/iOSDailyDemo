//
//  OCClass.m
//  TestSwiftSetClass
//
//  Created by BrookXy on 2022/1/7.
//

#import "OCClass.h"

@implementation OCClass

+ (instancetype)createInstance {
    return (OCClass *)[[NSObject alloc] init];
}

+ (BOOL)isTrue {
    OCClass *ins = [self createInstance];
    return [ins isKindOfClass:[OCClass class]];
}

+ (BOOL)oc_isKindOfClass:(Class)classB object:(id)object {
    return [object isKindOfClass:classB];
}

+ (Class)getClassOfObject:(id)object {
    __auto_type name = object_getClassName(object);
    __auto_type className = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
    return NSClassFromString(className);
}
@end


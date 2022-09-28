//
//  Person.m
//  TestOCInstanceMethodClassMethod
//
//  Created by beforeold on 2022/9/28.
//

#import "Person.h"

@interface Person ()
{
    NSString *_name;
}

@end

@implementation Person

+ (void)showPointer {
    __auto_type ins = [[Person alloc] init];
    NSLog(@"heap ins: %p", ins);
    NSLog(@"heap var: %p", &(ins->_name));
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _name = @"beforeold";
    }
    return self;
}


- (void)speek {
    NSLog(@"speek: %@", self->_name);
}


@end

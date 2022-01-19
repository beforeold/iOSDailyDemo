//
//  Person.m
//  TestOCSwiftGenericMacro
//
//  Created by 席萍萍Brook.dinglan on 2021/12/28.
//

#import "Person.h"

@implementation Person

- (Animal *)getPet {
    return [[Animal alloc] init];
}

@end

@implementation Animal


@end


void foo(void) {
    __auto_type p = [[Person<Person *> alloc] init];
    __auto_type pet = [p getPet];
    NSLog(@"pet= %@", pet);
    
    
    __auto_type animal = [[metamacro_concat_(Ani, mal) alloc] init];
    NSLog(@"animal: %@", animal);
}

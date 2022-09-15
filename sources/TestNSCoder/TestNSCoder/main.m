//
//  main.m
//  TestNSCoder
//
//  Created by 席萍萍Brook.dinglan on 2021/11/11.
//

#import <Foundation/Foundation.h>

@interface Subclass: NSObject <NSCoding>

@property (nonatomic, copy) NSDictionary *dict;

@end

@implementation Subclass

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        _dict = [coder decodeObjectForKey:@"key"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_dict forKey:@"key"];
}


@end

@interface Person : NSObject <NSCoding>

@property (nonatomic, strong) Subclass *sub;

@end

@implementation Person

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        _sub = [coder decodeObjectForKey:@"key"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_sub forKey:@"key"];
}

@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        __auto_type pp = [[Person alloc] init];
        __auto_type sub = [[Subclass alloc] init];
        sub.dict = @{@"name" : @"brook"};
        pp.sub = sub;
        
        NSError *error;
        __auto_type data = [NSKeyedArchiver archivedDataWithRootObject:pp requiringSecureCoding:NO error:&error];
        Person *pp2 = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        NSLog(@"-- %@", pp2.sub.dict);
    }
    return 0;
}

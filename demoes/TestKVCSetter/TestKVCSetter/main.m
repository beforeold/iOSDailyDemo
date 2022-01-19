//
//  main.m
//  TestKVCSetter
//
//  Created by 席萍萍Brook.dinglan on 2021/8/18.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (nonatomic, copy) NSString *name;

@end

@implementation Person
@synthesize name = _name;

- (void)setName:(NSString *)name {
    _name = [name copy];
    
    NSLog(@"xxxx");
}


- (NSString *)name {
    return _name;
}

@end


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
        __auto_type ins = [[Person alloc] init];
        [ins setValue:@"Nice" forKey:@"name"];
        NSLog(@"end: %@", [ins valueForKey:@"name"]);
    }
    return 0;
}

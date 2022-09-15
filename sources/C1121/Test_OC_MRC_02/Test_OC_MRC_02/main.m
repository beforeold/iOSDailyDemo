//
//  main.m
//  Test_OC_MRC_02
//
//  Created by Brook on 2019/11/27.
//  Copyright © 2019 br. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Book : NSObject

@property int page;

@end

@implementation Book

- (void)dealloc {
    NSLog(@"dealloc %@", self);
    [super dealloc];
}

@end

@interface Person : NSObject

@property (retain) Book *book;
@property (assign) Book *assignedBook;

@property (strong) Book *assignedBook2;
@property (weak) Book *assignedBook3;
@property (unsafe_unretained) Book *assignedBook4;
@property (nullable, weak) Book *assignedBook5;

@property (setter=giveName:, getter=niceName, retain) NSString *name;

@end

@implementation Person

- (void)dealloc {
    NSLog(@"dealloc %@", self);
    
    // 属性虽然声明了，只影响成员及其 setter/getter，不过 dealloc 仍旧要手动释放
    [_book release];
    
    /*
     [self giveName:@""];
     [self niceName];
     NSString *name = self.name;
     self.name = @"";
     */
    
    
    [super dealloc];
}

@end


int main(int argc, const char * argv[]) {
    
    Person *pp = [[Person alloc] init];
    Book *bb = [[Book alloc] init];
    
    pp.book = bb;
    
    [bb release];
    [pp release];
    
    return 0;
}

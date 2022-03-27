//
//  OCPerson.m
//  TestNSNullBridging
//
//  Created by BrookXy on 2022/3/25.
//

#import "OCPerson.h"
#import "TestNSNullBridging-Swift.h"


@interface SomeNullableArray<ObjectType> : NSArray<ObjectType>

/// 原始数组
@property (nonatomic, copy, readonly) NSArray *origin;

/** 仅支持以下接口 */
- (NSUInteger)count;
- (ObjectType)objectAtIndex:(NSUInteger)index;
- (void)addObject:(ObjectType)object;
- (void)removeAllObjects;
- (ObjectType)firstObject;
- (ObjectType)lastObject;

@end


@implementation OCPerson

+ (void)test {
    __auto_type ins = [[SwiftCar alloc] init];
    [ins playWithArgs:@[@1, @2]];
    [ins playWithArgs:@[NSNull.null, NSNull.null]];
    
    __auto_type dxArray = [[SomeNullableArray alloc] init];
    [dxArray addObject:@5];
    [dxArray addObject:NSNull.null];
    [ins playWithArgs:dxArray];
}

@end


@interface SomeNullableArray () {
    NSMutableArray *embeddedArray;
}
@end

@implementation SomeNullableArray

- (id)copy {
    return [super copy];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        embeddedArray = [NSMutableArray new];
    }
    return self;
}

-(NSArray *)origin {
    return [embeddedArray copy];
}

- (NSUInteger)hash {
    return [embeddedArray hash];
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    return [self isEqualToArray:object];
}

- (BOOL)isEqualToArray:(SomeNullableArray *)otherArray {
    if (self == otherArray) {
        return YES;
    }
    if ([otherArray isKindOfClass:[SomeNullableArray class]]) {
        return [embeddedArray isEqualToArray:otherArray->embeddedArray];
    } else if ([otherArray isKindOfClass:[NSArray class]]) {
        return [embeddedArray isEqualToArray:otherArray];
    }
    return NO;
}

- (NSUInteger)count {
    return [embeddedArray count];
}


- (id)objectAtIndex:(NSUInteger)index {
    if (index >= embeddedArray.count) {
        return nil;
    }
    id ret = [embeddedArray objectAtIndex:index];
    return ret == [NSNull null] ? nil : ret;
}

- (void)addObject:(id)object {
    [embeddedArray addObject:object ? : [NSNull null]];
}

- (void)removeAllObjects {
    [embeddedArray removeAllObjects];
}

- (id)firstObject {
    id ret = [embeddedArray firstObject];
    return ret != [NSNull null] ? ret : nil;
}

- (id)lastObject {
    id ret = [embeddedArray lastObject];
    return ret != [NSNull null] ? ret : nil;
}

@end

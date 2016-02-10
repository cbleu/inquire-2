//
//  NSArray+reversedArray.m
//  inquire
//
//  Created by Nicolas GARNAULT on 30/01/11.
//  Copyright 2011 Counterwinds. All rights reserved.
//

#import "NSArray+reversedArray.h"


@implementation NSArray (Reverse)

- (NSArray *)reversedArray {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self count]];
    NSEnumerator *enumerator = [self reverseObjectEnumerator];
    for (id element in enumerator) {
        [array addObject:element];
    }
    return array;
}

@end

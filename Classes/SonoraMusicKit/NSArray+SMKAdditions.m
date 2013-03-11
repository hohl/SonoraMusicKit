//
//  NSArray+SMKAdditions.m
//  SNRMusicKit
//
//  Created by Michael Hohl on 05.11.12.
//  Copyright (c) 2012 Indragie Karunaratne. All rights reserved.
//

#import "NSArray+SMKAdditions.h"

@implementation NSArray (SMKAdditions)

- (NSArray *)SMK_shuffledArray
{
    NSUInteger count = [self count];
    NSMutableArray *newArray = [NSMutableArray arrayWithArray:self];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop) {
        NSUInteger nElements = count - index;
        NSUInteger n = (arc4random_uniform((u_int32_t)nElements)) + index;
        [newArray exchangeObjectAtIndex:index withObjectAtIndex:n];
    }];
    return newArray;
}

@end

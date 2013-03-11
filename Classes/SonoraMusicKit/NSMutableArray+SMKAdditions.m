//
//  NSMutableArray+SMKAdditions.m
//  SNRMusicKit
//
//  Created by Indragie Karunaratne on 2012-08-25.
//  Copyright (c) 2012 Indragie Karunaratne. All rights reserved.
//

#import "NSMutableArray+SMKAdditions.h"

@implementation NSMutableArray (SMKAdditions)
- (void)SMK_processWithSortDescriptors:(NSArray *)sortDescriptors predicate:(NSPredicate*)predicate
{
    if (predicate)
        [self filterUsingPredicate:predicate];
    if ([sortDescriptors count])
        [self sortUsingDescriptors:sortDescriptors];
}

+ (NSMutableArray *)SMK_arrayWithNumbersCountingTo:(NSUInteger)limit
{
    NSMutableArray *newArray = [NSMutableArray arrayWithCapacity:limit];
    for (NSUInteger index = 0; index < limit; ++index) {
        [newArray addObject:[NSNumber numberWithUnsignedInteger:index]];
    }
    return newArray;
}
@end

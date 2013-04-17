//
//  NSMutableArray+SMKAdditions.m
//  SNRMusicKit
//
//  Created by Indragie Karunaratne on 2012-08-25.
//  Copyright (c) 2012 Indragie Karunaratne. All rights reserved.
//

#import "NSMutableArray+SMKAdditions.h"
#import "SMKPredicates.h"

@implementation NSMutableArray (SMKAdditions)
- (void)SMK_processWithSortDescriptors:(NSArray *)sortDescriptors predicates:(NSDictionary *)predicates
{
    // ToDo: Fix this and change NSPredicate to NSDicitionary!
    [predicates enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        NSPredicate *predicate;
        if ([key isEqual:SMKPredicateKeyUniqueIdentifier]) {
            [NSPredicate predicateWithFormat:@"%@ == %@" argumentArray:@[key, value]];
        } else {
            [NSPredicate predicateWithFormat:@"%@ CONTAINS %@" argumentArray:@[key, value]];
        }
        [self filterUsingPredicate:predicate];
    }];
    if ([sortDescriptors count]) {
        [self sortUsingDescriptors:sortDescriptors];
    }
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

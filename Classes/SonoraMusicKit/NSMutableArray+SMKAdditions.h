//
//  NSMutableArray+SMKAdditions.h
//  SNRMusicKit
//
//  Created by Indragie Karunaratne on 2012-08-25.
//  Copyright (c) 2012 Indragie Karunaratne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (SMKAdditions)
/**
 @param sortDescriptors Array of sort descriptors to sort the array with
 @param predicate NSPredicate to filter the array
 */
- (void)SMK_processWithSortDescriptors:(NSArray *)sortDescriptors predicates:(NSDictionary *)predicates;
/**
 @discussion If you pass 3 as limit you will result with @[@0,@1,@2].
 @param limit number of items to create in the new array.
 @return an array with counting NSNumber starting by 0
 */
+ (NSMutableArray *)SMK_arrayWithNumbersCountingTo:(NSUInteger)limit;
@end

//
//  SMKArtist.h
//  SNRMusicKit
//
//  Created by Indragie Karunaratne on 2012-08-21.
//  Updated by Michael Hohl on 2013-04-16.
//  Copyright (c) 2012 Indragie Karunaratne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMKContentObject.h"

@protocol SMKArtist <NSObject, SMKContentObject>
@required
/**
 This method will fetch the albums asynchronously and call the completion handler when finished.
 @param sortDescriptors Array of NSSortDescriptor objects used to sort the content
 @param predicates A dictionary of predicates to filter the results with
 @discussion This method is asynchronous and will return immediately.
*/
- (void)fetchAlbumsWithSortDescriptors:(NSArray *)sortDescriptors
                            predicates:(NSDictionary *)predicates
                     completionHandler:(void(^)(NSArray *albums, NSError *error))handler;

/**
 This method will fetch the tracks asynchronously and call the completion handler when finished.
 @param sortDescriptors Array of NSSortDescriptor objects used to sort the content
 @param predicates A predicate to filter the results with. Use SMKContentSource +predicateClass to find out which
 class the content source expects its predicate to use.
 @discussion This method is asynchronous and will return immediately.
 */
- (void)fetchTracksWithSortDescriptors:(NSArray *)sortDescriptors
                            predicates:(NSDictionary *)predicates
                     completionHandler:(void(^)(NSArray *tracks, NSError *error))handler;

@optional

/**
 @return The genre of the song.
 */
- (NSString *)genre;
@end

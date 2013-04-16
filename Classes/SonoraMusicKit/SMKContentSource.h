//
//  SMKContentSource.h
//  SNRMusicKit
//
//  Created by Indragie Karunaratne on 2012-08-21.
//  Updated by Michael Hohl on 2013-04-16.
//  Copyright (c) 2012 Indragie Karunaratne. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SMKAuthenticationController;
@protocol SMKContentSource <NSObject>
@required
/**
 Easy to read display name. Like 'Spotify' for SMKSpotifyContentSource. This name may be used for displaying to the user.
 */
- (NSString *)displayName;

/**
 This method will fetch the playlists asynchronously and call the completion handler when finished.
 @param sortDescriptors Array of NSSortDescriptor objects used to sort the content
 @param predicates A dictionary of predicates to filter the results with. Use SMKContentSource +predicateClass to find 
 out which class the content source expects its predicate to use.
 @discussion This method is asynchronous and will return immediately.
 */
- (void)fetchPlaylistsWithSortDescriptors:(NSArray *)sortDescriptors
                               predicates:(NSDictionary *)predicates
                        completionHandler:(void(^)(NSArray *playlists, NSError *error))handler;

/**
 This method will fetch the artists asynchronously and call the completion handler when finished.
 @param sortDescriptors Array of NSSortDescriptor objects used to sort the content
 @param predicates A dictionary of predicates to filter the results with. Use SMKContentSource +predicateClass to find 
 out which class the content source expects its predicate to use.
 @discussion This method is asynchronous and will return immediately.
 */
- (void)fetchArtistsWithSortDescriptors:(NSArray *)sortDescriptors
                             predicates:(NSDictionary *)predicates
                      completionHandler:(void(^)(NSArray *artists, NSArray *sections, NSError *error))handler;

/**
 This method will fetch the albums asynchronously and call the completion handler when finished.
 @param sortDescriptors Array of NSSortDescriptor objects used to sort the content
 @param predicates A dictionary of predicates to filter the results with. Use SMKContentSource +predicateClass to find 
 out which class the content source expects its predicate to use.
 @discussion This method is asynchronous and will return immediately.
 */
- (void)fetchAlbumsWithSortDescriptors:(NSArray *)sortDescriptors
                            predicates:(NSDictionary *)predicates
                     completionHandler:(void(^)(NSArray *albums, NSArray *sections, NSError *error))handler;

/**
 This method will fetch the tracks asynchronously and call the completion handler when finished.
 @param sortDescriptors Array of NSSortDescriptor objects used to sort the content
 @param predicates A dictionary of predicates to filter the results with. Use SMKContentSource +predicateClass to find 
 out which class the content source expects its predicate to use.
 @discussion This method is asynchronous and will return immediately.
 */
- (void)fetchTracksWithSortDescriptors:(NSArray *)sortDescriptors
                            predicates:(NSDictionary *)predicates
                     completionHandler:(void(^)(NSArray *tracks, NSArray *sections, NSError *error))handler;

/**
 @return Controller used for authentication.
 @discussion When there is no authentication required for this content source nil will be returned.
 */
- (id<SMKAuthenticationController>)authenticationController;
@end

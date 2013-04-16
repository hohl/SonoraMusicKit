//
//  SMKMPMediaHelpers.m
//  SNRMusicKit
//
//  Created by Indragie Karunaratne on 2012-08-27.
//  Copyright (c) 2012 Indragie Karunaratne. All rights reserved.
//

#import "SMKMPMediaHelpers.h"
#import "SMKPredicates.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation SMKMPMediaHelpers
+ (MPMediaPropertyPredicate *)predicateForArtistNameOfItem:(MPMediaItem *)item
{
    NSNumber *albumArtist = [item valueForProperty:MPMediaItemPropertyAlbumArtistPersistentID];
    NSString *artist = [item valueForProperty:MPMediaItemPropertyArtistPersistentID];
    if (albumArtist) {
        return [MPMediaPropertyPredicate predicateWithValue:albumArtist forProperty:MPMediaItemPropertyAlbumArtistPersistentID];
    } else {
        return [MPMediaPropertyPredicate predicateWithValue:artist forProperty:MPMediaItemPropertyArtistPersistentID];
    }
}

+ (NSSet *)predicatesFromDictionary:(NSDictionary *)smkPredicates
{
    NSMutableSet *mpPredicates = [NSMutableSet setWithCapacity:[smkPredicates count]];
    [smkPredicates enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        if ([key isEqual:SMKPredicateKeyUniqueIdentifier]) {
            [mpPredicates addObject:[MPMediaPropertyPredicate predicateWithValue:value forProperty:MPMediaItemPropertyPersistentID]];
        } else if ([key isEqual:SMKPredicateKeyTitle]) {
            [mpPredicates addObject:[MPMediaPropertyPredicate predicateWithValue:value forProperty:MPMediaItemPropertyTitle]];
        } else if ([key isEqual:SMKPredicateKeyArtistName]) {
            [mpPredicates addObject:[MPMediaPropertyPredicate predicateWithValue:value forProperty:MPMediaItemPropertyArtist]];
        } else if ([key isEqual:SMKPredicateKeyAlbumTitle]) {
            [mpPredicates addObject:[MPMediaPropertyPredicate predicateWithValue:value forProperty:MPMediaItemPropertyAlbumTitle]];
        } else {
            [mpPredicates addObject:[MPMediaPropertyPredicate predicateWithValue:value forProperty:key]];
        }
    }];
    return mpPredicates;
}
@end

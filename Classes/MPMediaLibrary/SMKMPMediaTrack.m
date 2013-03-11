//
//  SMKMPMediaTrack.m
//  SNRMusicKit
//
//  Created by Indragie Karunaratne on 2012-08-27.
//  Copyright (c) 2012 Indragie Karunaratne. All rights reserved.
//

#import "SMKMPMediaTrack.h"
#import "SMKMPMediaAlbum.h"
#import "SMKMPMediaHelpers.h"
#import "SMKAVQueuePlayer.h"
#import "SMKMPMusicPlayer.h"
#import "SMKMPMediaContentSource.h"

@interface SMKMPMediaAlbum (SMKInternal)
- (id)initWithRepresentedObject:(MPMediaItem*)object contentSource:(id<SMKContentSource>)contentSource;
@end

@implementation SMKMPMediaTrack

- (id)initWithRepresentedObject:(MPMediaItem*)object contentSource:(id<SMKContentSource>)contentSource
{
    if ((self = [super init])) {
        _representedObject = object;
        _contentSource = contentSource;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super init])) {
        _representedObject = [aDecoder decodeObjectForKey:@"representedObject"];
        _contentSource = [SMKMPMediaContentSource sharedInstance];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.representedObject forKey:@"representedObject"];
}

#pragma mark - SMKContentObject

- (NSString *)uniqueIdentifier
{
    return [self.representedObject valueForProperty:MPMediaItemPropertyPersistentID];
}

- (NSString *)name
{
    return [self.representedObject valueForProperty:MPMediaItemPropertyTitle];
}

+ (NSSet *)supportedSortKeys
{
    return [NSSet setWithObjects:@"name", @"artistName", @"albumArtistName", @"duration", @"composer", @"trackNumber", @"discNumber", @"playCount", @"lyrics", @"genre", @"rating", @"lastPlayedDate", nil];
}

- (Class)playerClass
{
    return (self.playbackURL != nil) ? [SMKAVQueuePlayer class] : [SMKMPMusicPlayer class];
}

#pragma mark - SMKTrack

- (id<SMKAlbum>)album
{
    NSNumber *albumPersistentID = [self.representedObject valueForProperty:MPMediaItemPropertyAlbumPersistentID];
    MPMediaQuery *albumQuery = [MPMediaQuery albumsQuery];
    MPMediaPropertyPredicate *albumPredicate = [MPMediaPropertyPredicate predicateWithValue:albumPersistentID forProperty:MPMediaItemPropertyAlbumPersistentID];
    albumQuery.filterPredicates = [NSSet setWithObject:albumPredicate];
    NSArray *collections = albumQuery.collections;
    if ([collections count]) {
        return [[SMKMPMediaAlbum alloc] initWithRepresentedObject:[collections objectAtIndex:0] contentSource:self.contentSource];
    }
    return nil;
}

- (id<SMKArtist>)artist
{
    return [self.album artist];
}

- (NSString *)artistName
{
    return [self.representedObject valueForProperty:MPMediaItemPropertyArtist];
}

- (NSString *)albumArtistName
{
    return [self.representedObject valueForProperty:MPMediaItemPropertyAlbumArtist];
}

- (NSTimeInterval)duration
{
    return [[self.representedObject valueForProperty:MPMediaItemPropertyPlaybackDuration] doubleValue];
}

- (NSString *)composer
{
    return [self.representedObject valueForProperty:MPMediaItemPropertyComposer];
}

- (NSUInteger)trackNumber
{
    return [[self.representedObject valueForProperty:MPMediaItemPropertyAlbumTrackNumber] unsignedIntegerValue];
}

- (NSUInteger)discNumber
{
    return [[self.representedObject valueForProperty:MPMediaItemPropertyDiscNumber] unsignedIntegerValue];
}

- (NSUInteger)playCount
{
    return [[self.representedObject valueForProperty:MPMediaItemPropertyPlayCount] unsignedIntegerValue];
}

- (NSString *)lyrics
{
    return [self.representedObject valueForProperty:MPMediaItemPropertyLyrics];
}

- (NSString *)genre
{
    return [self.representedObject valueForProperty:MPMediaItemPropertyGenre];
}

- (NSUInteger)rating
{
    return [[self.representedObject valueForProperty:MPMediaItemPropertyRating] unsignedIntegerValue];
}

- (NSDate *)lastPlayedDate
{
    return [self.representedObject valueForProperty:MPMediaItemPropertyLastPlayedDate];
}

- (NSURL *)playbackURL
{
    return [self.representedObject valueForProperty:MPMediaItemPropertyAssetURL];
}

- (BOOL)isPlayable
{
    return [self.representedObject valueForProperty:MPMediaItemPropertyAssetURL] != nil;
}

#pragma mark - SMKArtworkObject

- (void)fetchArtworkWithSize:(SMKArtworkSize)size
           completionHandler:(void(^)(SMKPlatformNativeImage *image, NSError *error))handler
{
    CGSize targetSize = CGSizeZero;
    switch (size) {
        case SMKArtworkSizeSmallest:
            targetSize = CGSizeMake(72.0, 72.0);
            break;
        case SMKArtworkSizeSmall:
            targetSize = CGSizeMake(150.0, 150.0);
            break;
        case SMKArtworkSizeLarge:
            targetSize = CGSizeMake(300.0, 300.0);
            break;
        case SMKArtworkSizeLargest:
            targetSize = CGSizeMake(600.0, 600.0);
        default:
            break;
    }
    [self fetchArtworkWithTargetSize:targetSize completionHandler:handler];
}

- (void)fetchArtworkWithTargetSize:(CGSize)size completionHandler:(void(^)(SMKPlatformNativeImage *image, NSError *error))handler
{
    __weak SMKMPMediaTrack *weakSelf = self;
    dispatch_async([(SMKMPMediaContentSource*)self.contentSource queryQueue], ^{
        SMKMPMediaTrack *strongSelf = weakSelf;
        MPMediaItemArtwork *artwork = [strongSelf.representedObject valueForProperty:MPMediaItemPropertyArtwork];
        UIImage *image = [artwork imageWithSize:size];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (handler) handler(image, nil);
        });
    });
}

@end

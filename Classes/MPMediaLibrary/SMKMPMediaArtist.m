//
//  SMKMPMediaArtist.m
//  SNRMusicKit
//
//  Created by Indragie Karunaratne on 2012-08-27.
//  Copyright (c) 2012 Indragie Karunaratne. All rights reserved.
//

#import "SMKMPMediaArtist.h"
#import "SMKMPMediaContentSource.h"
#import "SMKMPMediaHelpers.h"

@interface SMKMPMediaAlbum (SMKInternal)
- (id)initWithRepresentedObject:(MPMediaItemCollection *)object contentSource:(id<SMKContentSource>)contentSource;
@end

@interface SMKMPMediaTrack (SMKInternal)
- (id)initWithRepresentedObject:(MPMediaItem*)object contentSource:(id<SMKContentSource>)contentSource;
@end

@implementation SMKMPMediaArtist

- (id)initWithRepresentedObject:(MPMediaItemCollection *)object contentSource:(id<SMKContentSource>)contentSource
{
    if ((self = [super init])) {
        _representedObject = object;
        _contentSource = contentSource;
    }
    return self;
}

#pragma mark - SMKContentObject

- (NSString *)uniqueIdentifier
{
    return [self.representedObject valueForProperty:MPMediaItemPropertyPersistentID];
}

- (NSString *)name
{
    NSString *albumArtist = [self.representedObject.representativeItem valueForProperty:MPMediaItemPropertyAlbumArtist];
    NSString *artist = [self.representedObject.representativeItem valueForProperty:MPMediaItemPropertyArtist];
    return albumArtist ?: artist;
}

+ (NSSet *)supportedSortKeys
{
    return [NSSet setWithObjects:@"name", nil];
}

#pragma mark - SMKArtist

- (void)fetchAlbumsWithSortDescriptors:(NSArray *)sortDescriptors
                             predicate:(id)predicate
                     completionHandler:(void(^)(NSArray *albums, NSError *error))handler
{
    __weak SMKMPMediaArtist *weakSelf = self;
    dispatch_async([(SMKMPMediaContentSource*)self.contentSource queryQueue], ^{
        SMKMPMediaArtist *strongSelf = weakSelf;
        MPMediaQuery *albumsQuery = [MPMediaQuery albumsQuery];
        MPMediaItem *item = strongSelf.representedObject.representativeItem;
        MPMediaPropertyPredicate *artistPredicate = [SMKMPMediaHelpers predicateForArtistNameOfItem:item];
        if (artistPredicate) {
            NSMutableSet *predicates = [NSMutableSet setWithObject:artistPredicate];
            if (predicate)
                [predicates addObjectsFromArray:[[(SMKMPMediaPredicate *)predicate predicates] allObjects]];
            albumsQuery.filterPredicates = predicates;
            NSArray *collections = albumsQuery.collections;
            NSMutableArray *albums = [NSMutableArray arrayWithCapacity:[collections count]];
            [collections enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                SMKMPMediaAlbum *album = [[SMKMPMediaAlbum alloc] initWithRepresentedObject:obj contentSource:strongSelf.contentSource];
                [albums addObject:album];
            }];
            if ([sortDescriptors count])
                [albums sortUsingDescriptors:sortDescriptors];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (handler) handler(albums, nil);
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (handler) handler(nil, nil);
            });
        }
    });
}

- (void)fetchTracksWithSortDescriptors:(NSArray *)sortDescriptors
                             predicate:(id)predicate
                     completionHandler:(void(^)(NSArray *tracks, NSError *error))handler
{
    __weak SMKMPMediaArtist *weakSelf = self;
    dispatch_async([(SMKMPMediaContentSource*)self.contentSource queryQueue], ^{
        SMKMPMediaArtist *strongSelf = weakSelf;
        NSMutableArray *tracks = [NSMutableArray array];
        NSArray *items = nil;
        if (!predicate) {
            items = strongSelf.representedObject.items;
        } else {
            MPMediaQuery *songsQuery = [MPMediaQuery songsQuery];
            MPMediaPropertyPredicate *artistPredicate = [MPMediaPropertyPredicate predicateWithValue:[strongSelf.representedObject valueForProperty:MPMediaItemPropertyPersistentID] forProperty:MPMediaItemPropertyArtistPersistentID];
            NSMutableSet *predicates = [NSMutableSet setWithObject:artistPredicate];
            if (predicate)
                [predicates addObjectsFromArray:[[(SMKMPMediaPredicate *)predicate predicates] allObjects]];
            items = songsQuery.items;
        }
        [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            SMKMPMediaTrack *track = [[SMKMPMediaTrack alloc] initWithRepresentedObject:obj contentSource:strongSelf.contentSource];
            [tracks addObject:track];
        }];
        if ([sortDescriptors count])
            [tracks sortUsingDescriptors:sortDescriptors];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (handler) handler(tracks, nil);
        });
    });
}

- (NSString *)genre
{
    return [self.representedObject.representativeItem valueForProperty:MPMediaItemPropertyGenre];
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
    __weak SMKMPMediaArtist *weakSelf = self;
    dispatch_async([(SMKMPMediaContentSource*)self.contentSource queryQueue], ^{
        SMKMPMediaArtist *strongSelf = weakSelf;
        MPMediaItemArtwork *artwork = [strongSelf.representedObject.representativeItem valueForProperty:MPMediaItemPropertyArtwork];
        UIImage *image = [artwork imageWithSize:size];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (handler) handler(image, nil);
        });
    });
}


@end

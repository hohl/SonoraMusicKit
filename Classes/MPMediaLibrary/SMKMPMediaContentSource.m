//
//  SMKMPMediaContentSource.m
//  SNRMusicKit
//
//  Created by Indragie Karunaratne on 2012-08-24.
//  Copyright (c) 2012 Indragie Karunaratne. All rights reserved.
//

#import "SMKMPMediaContentSource.h"
#import "SMKSection.h"
#import <MediaPlayer/MediaPlayer.h>

@interface SMKMPMediaPlaylist (SMKInternal)
- (id)initWithRepresentedObject:(MPMediaItemCollection*)object contentSource:(id<SMKContentSource>)contentSource;
@end

@interface SMKMPMediaArtist (SMKInternal)
- (id)initWithRepresentedObject:(MPMediaItemCollection *)object contentSource:(id<SMKContentSource>)contentSource;
@end

@interface SMKMPMediaTrack (SMKInternal)
- (id)initWithRepresentedObject:(MPMediaItem*)object contentSource:(id<SMKContentSource>)contentSource;
@end

@interface SMKMPMediaAlbum (SMKInternal)
- (id)initWithRepresentedObject:(MPMediaItemCollection *)object contentSource:(id<SMKContentSource>)contentSource;
@end


@implementation SMKMPMediaContentSource

+ (SMKMPMediaContentSource *)sharedInstance
{    
	static SMKMPMediaContentSource *_sharedInstance;
	if(!_sharedInstance) {
		static dispatch_once_t oncePredicate;
		dispatch_once(&oncePredicate, ^{
			_sharedInstance = [[super allocWithZone:nil] init];
        });
    }
    
    return _sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{    
	return [self sharedInstance];
}

- (id)copyWithZone:(NSZone *)zone
{
	return self;
}

- (id)init
{
    if ((self = [super init])) {
        _queryQueue = dispatch_queue_create("com.indragie.SNRMusicKit.MPMediaQueryQueue", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (void)dealloc
{
    dispatch_release(_queryQueue);
}

- (void)fetchPlaylistsWithSortDescriptors:(NSArray *)sortDescriptors
                                predicate:(SMKMPMediaPredicate *)predicate
                        completionHandler:(void(^)(NSArray *playlists, NSError *error))handler
{
    __weak SMKMPMediaContentSource *weakSelf = self;
    dispatch_async(_queryQueue, ^{
        SMKMPMediaContentSource *strongSelf = weakSelf;
        MPMediaQuery *playlistsQuery = [MPMediaQuery playlistsQuery];
        if (predicate) playlistsQuery.filterPredicates = predicate.predicates;
        NSArray *collections = playlistsQuery.collections;
        NSMutableArray *playlists = [NSMutableArray arrayWithCapacity:[collections count]];
        [collections enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            SMKMPMediaPlaylist *playlist = [[SMKMPMediaPlaylist alloc] initWithRepresentedObject:obj contentSource:strongSelf];
            [playlists addObject:playlist];
        }];
        if ([sortDescriptors count])
            [playlists sortUsingDescriptors:sortDescriptors];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (handler) handler(playlists, nil);
        });
    });
}

- (NSString *)displayName { return @"iTunes"; }

+ (Class)predicateClass { return [SMKMPMediaPredicate class]; }


- (void)fetchArtistsWithSortDescriptors:(NSArray *)sortDescriptors
                              predicate:(SMKMPMediaPredicate *)predicate
                      completionHandler:(void(^)(NSArray *artists, NSArray *sections, NSError *error))handler
{
    __weak SMKMPMediaContentSource *weakSelf = self;
    dispatch_async(self.queryQueue, ^{
        SMKMPMediaContentSource *strongSelf = weakSelf;
        MPMediaQuery *artistsQuery = [MPMediaQuery artistsQuery];
        artistsQuery.groupingType = MPMediaGroupingAlbumArtist;
        if (predicate) artistsQuery.filterPredicates = predicate.predicates;
        NSArray *collections = artistsQuery.collections;
        NSMutableArray *artists = [NSMutableArray arrayWithCapacity:[collections count]];
        [collections enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            SMKMPMediaArtist *artist = [[SMKMPMediaArtist alloc] initWithRepresentedObject:obj contentSource:strongSelf];
            [artists addObject:artist];
        }];
        NSMutableArray *artistSections = nil;
        if ([sortDescriptors count])
        {
            [artists sortUsingDescriptors:sortDescriptors];
        }
        else
        {
            NSArray *collectionSections = artistsQuery.collectionSections;
            artistSections = [NSMutableArray arrayWithCapacity:[collectionSections count]];
            [collectionSections enumerateObjectsUsingBlock:^(MPMediaQuerySection *obj, NSUInteger idx, BOOL *stop) {
                SMKSection *section = [[SMKSection alloc] initWithTitle:obj.title range:obj.range];
                [artistSections addObject:section];
            }];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (handler) handler(artists, artistSections, nil);
        });
    });
}

- (void)fetchAlbumsWithSortDescriptors:(NSArray *)sortDescriptors
                             predicate:(SMKMPMediaPredicate *)predicate
                     completionHandler:(void(^)(NSArray *albums, NSArray *sections, NSError *error))handler
{
    __weak SMKMPMediaContentSource *weakSelf = self;
    dispatch_async(self.queryQueue, ^{
        SMKMPMediaContentSource *strongSelf = weakSelf;
        MPMediaQuery *albumsQuery = [MPMediaQuery albumsQuery];
        if (predicate) albumsQuery.filterPredicates = predicate.predicates;
        NSArray *collections = albumsQuery.collections;
        NSMutableArray *albums = [NSMutableArray arrayWithCapacity:[collections count]];
        [collections enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            SMKMPMediaAlbum *album = [[SMKMPMediaAlbum alloc] initWithRepresentedObject:obj contentSource:strongSelf];
            [albums addObject:album];
        }];
        NSMutableArray *albumSections = nil;
        if ([sortDescriptors count]) {
            [albums sortUsingDescriptors:sortDescriptors];
        }
        else
        {
            NSArray *collectionSections = albumsQuery.collectionSections;
            albumSections = [NSMutableArray arrayWithCapacity:[collectionSections count]];
            [collectionSections enumerateObjectsUsingBlock:^(MPMediaQuerySection *obj, NSUInteger idx, BOOL *stop) {
                SMKSection *section = [[SMKSection alloc] initWithTitle:obj.title range:obj.range];
                [albumSections addObject:section];
            }];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (handler) handler(albums, albumSections, nil);
        });
    });
}

- (void)fetchTracksWithSortDescriptors:(NSArray *)sortDescriptors
                             predicate:(SMKMPMediaPredicate *)predicate
                     completionHandler:(void(^)(NSArray *tracks, NSArray *sections, NSError *error))handler
{
    __weak SMKMPMediaContentSource *weakSelf = self;
    dispatch_async(self.queryQueue, ^{
        SMKMPMediaContentSource *strongSelf = weakSelf;
        MPMediaQuery *songsQuery = [MPMediaQuery songsQuery];
        if (predicate) songsQuery.filterPredicates = predicate.predicates;
        NSArray *collections = songsQuery.items;
        NSMutableArray *tracks = [NSMutableArray arrayWithCapacity:[collections count]];
        [collections enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            SMKMPMediaTrack *track = [[SMKMPMediaTrack alloc] initWithRepresentedObject:obj contentSource:strongSelf];
            [tracks addObject:track];
        }];
        NSMutableArray *songSections = nil;
        if ([sortDescriptors count]) {
            [tracks sortUsingDescriptors:sortDescriptors];
        }
        else
        {
            NSArray *collectionSections = songsQuery.itemSections;
            songSections = [NSMutableArray arrayWithCapacity:[collectionSections count]];
            [collectionSections enumerateObjectsUsingBlock:^(MPMediaQuerySection *obj, NSUInteger idx, BOOL *stop) {
                SMKSection *section = [[SMKSection alloc] initWithTitle:obj.title range:obj.range];
                [songSections addObject:section];
            }];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (handler) handler(tracks, songSections, nil);
        });
    });
}

@end

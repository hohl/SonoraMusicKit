//
//  SMKSpotifyContentSource.m
//  SNRMusicKit
//
//  Created by Indragie Karunaratne on 2012-08-24.
//  Copyright (c) 2012 Indragie Karunaratne. All rights reserved.
//

#import "SMKSpotifyContentSource.h"
#import "SMKSpotifyConstants.h"
#import "SMKSpotifyPlayer.h"
#import "NSObject+SMKSpotifyAdditions.h"
#import "NSMutableArray+SMKAdditions.h"
#import "SPToplist+SMKPlaylist.h"
#import "SMKSection.h"
#import <MAKVONotificationCenter/MAKVONotificationCenter.h>

@interface SMKSpotifyContentSource ()
- (id)_initWithApplicationKey:(NSData *)appKey userAgent:(NSString *)userAgent loadingPolicy:(SPAsyncLoadingPolicy)policy error:(NSError *__autoreleasing *)error;
@end

@implementation SMKSpotifyContentSource

#pragma mark - SMKContentSource

- (NSString *)name { return @"Spotify"; }

- (NSString *)displayName { return @"Spotify"; }

+ (Class)predicateClass { return [NSString class]; }

- (void)fetchPlaylistsWithSortDescriptors:(NSArray *)sortDescriptors
                                predicate:(NSPredicate *)predicate
                        completionHandler:(void(^)(NSArray *playlists, NSError *error))handler
{
    __weak SPSession *weakSelf = self;
    [self SMK_spotifyWaitAsyncThen:^{
        SPSession *strongSelf = weakSelf;
        dispatch_async([SMKSpotifyContentSource spotifyLocalQueue], ^{
            __block SPToplist *globalToplist = nil;
            __block SPToplist *userToplist = nil;
            globalToplist = [SPToplist globalToplistInSession:strongSelf];
            userToplist = [SPToplist toplistForCurrentUserInSession:strongSelf];
            dispatch_group_t group = dispatch_group_create();
            dispatch_group_enter(group);
            [SPAsyncLoading waitUntilLoaded:@[strongSelf.starredPlaylist, strongSelf.inboxPlaylist, strongSelf.userPlaylists, globalToplist, userToplist] timeout:SMKSpotifyDefaultLoadingTimeout then:^(NSArray *loadedItems, NSArray *notLoadedItems) {
                [strongSelf.userPlaylists.playlists enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    [obj SMK_spotifyWaitAsyncThen:nil group:group];
                }];
                dispatch_group_leave(group);
            }];
            dispatch_group_notify(group, [SMKSpotifyContentSource spotifyLocalQueue], ^{
                strongSelf.inboxPlaylist.name = @"Inbox";
                strongSelf.starredPlaylist.name = @"Starred";
                globalToplist.name = @"Global Toplist";
                userToplist.name = @"My Toplist";
                NSMutableArray *playlists = [NSMutableArray arrayWithObjects:strongSelf.inboxPlaylist, strongSelf.starredPlaylist, globalToplist, userToplist, nil];
                [playlists addObjectsFromArray:[strongSelf.userPlaylists flattenedPlaylists]];
                [playlists SMK_processWithSortDescriptors:sortDescriptors
                                                predicate:predicate];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (handler)
                        handler(playlists, nil);
                });
            });
            dispatch_release(group);
        });
    }];
}

- (void)fetchTracksWithSortDescriptors:(NSArray *)sortDescriptors predicate:(id)predicate completionHandler:(void (^)(NSArray *, NSArray *, NSError *))handler
{
    if (!predicate) {
        return handler(nil, nil, nil);
    }
    if (![predicate isKindOfClass:[SMKSpotifyContentSource predicateClass]]) {
        [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"[SMKSpotifyContentSource fetchTracksWithSortDescriptors:predicate:completionHandler:] expects a NSString as predicate! Instead a %@ got passed as argument.", [predicate class]] userInfo:nil];
        return;
    }
    
    __weak SPSession *weakSelf = self;
    [self SMK_spotifyWaitAsyncThen:^{
        SPSession *strongSelf = weakSelf;
        dispatch_async([SMKSpotifyContentSource spotifyLocalQueue], ^{
            __block SPSearch *search = [[SPSearch alloc] initWithSearchQuery:predicate inSession:strongSelf];
            [search addObservationKeyPath:@"loaded" options:0 block:^(MAKVONotification *notification) {
                handler(search.tracks, nil, nil);
                [search removeAllObservers];
            }];
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(SMKSpotifyDefaultLoadingTimeout * NSEC_PER_SEC));
            dispatch_after(popTime, [SMKSpotifyContentSource spotifyLocalQueue], ^{
                if (search) {
                    handler(nil, nil, SMKSpotifyLoadingTimeoutError());
                    [search removeAllObservers];
                    search = nil;
                }
            });
        });
    }];
}

- (void)fetchAlbumsWithSortDescriptors:(NSArray *)sortDescriptors predicate:(id)predicate completionHandler:(void (^)(NSArray *, NSArray *, NSError *))handler
{
    if (!predicate) {
        return handler(nil, nil, nil);
    }
    if (![predicate isKindOfClass:[SMKSpotifyContentSource predicateClass]]) {
        [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"[SMKSpotifyContentSource fetchAlbumsWithSortDescriptors:predicate:completionHandler:] expects a NSString as predicate! Instead a %@ got passed as argument.", [predicate class]] userInfo:nil];
        return;
    }
    
    __weak SPSession *weakSelf = self;
    [self SMK_spotifyWaitAsyncThen:^{
        SPSession *strongSelf = weakSelf;
        dispatch_async([SMKSpotifyContentSource spotifyLocalQueue], ^{
            __block SPSearch *search = [[SPSearch alloc] initWithSearchQuery:predicate inSession:strongSelf];
            [search addObservationKeyPath:@"loaded" options:0 block:^(MAKVONotification *notification) {
                handler(search.albums, nil, nil);
                [search removeAllObservers];
                search = nil;
            }];
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(SMKSpotifyDefaultLoadingTimeout * NSEC_PER_SEC));
            dispatch_after(popTime, [SMKSpotifyContentSource spotifyLocalQueue], ^{
                if (search) {
                    handler(nil, nil, SMKSpotifyLoadingTimeoutError());
                    [search removeAllObservers];
                    search = nil;
                }
            });
        });
    }];
}

- (void)fetchArtistsWithSortDescriptors:(NSArray *)sortDescriptors predicate:(id)predicate completionHandler:(void (^)(NSArray *, NSArray *, NSError *))handler
{
    if (!predicate) {
        return handler(nil, nil, nil);
    }
    if (![predicate isKindOfClass:[SMKSpotifyContentSource predicateClass]]) {
        [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"[SMKSpotifyContentSource fetchArtistsWithSortDescriptors:predicate:completionHandler:] expects a NSString as predicate! Instead a %@ got passed as argument.", [predicate class]] userInfo:nil];
        return;
    }
    
    __weak SPSession *weakSelf = self;
    [self SMK_spotifyWaitAsyncThen:^{
        SPSession *strongSelf = weakSelf;
        dispatch_async([SMKSpotifyContentSource spotifyLocalQueue], ^{
            __block SPSearch *search = [[SPSearch alloc] initWithSearchQuery:predicate inSession:strongSelf];
            [search addObservationKeyPath:@"loaded" options:0 block:^(MAKVONotification *notification) {
                handler(search.artists, nil, nil);
                [search removeAllObservers];
                search = nil;
            }];
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(SMKSpotifyDefaultLoadingTimeout * NSEC_PER_SEC));
            dispatch_after(popTime, [SMKSpotifyContentSource spotifyLocalQueue], ^{
                if (search) {
                    handler(nil, nil, SMKSpotifyLoadingTimeoutError());
                    [search removeAllObservers];
                    search = nil;
                }
            });
        });
    }];
}

#pragma mark - Accessors

static SMKSpotifyContentSource *_sharedContentSource = nil;

+ (SMKSpotifyContentSource *)sharedInstance
{
    @synchronized([SMKSpotifyContentSource class]) {
        return _sharedContentSource;
    }
}

+ (BOOL)initializeSharedInstanceWithApplicationKey:(NSData *)appKey userAgent:(NSString *)userAgent loadingPolicy:(SPAsyncLoadingPolicy)policy error:(NSError *__autoreleasing *)error
{
    @synchronized([SMKSpotifyContentSource class]) {
        _sharedContentSource = [[SMKSpotifyContentSource alloc] _initWithApplicationKey:appKey userAgent:userAgent loadingPolicy:policy error:error];
        
        if (!_sharedContentSource)
            return NO;
        return YES;
    }
}

- (id)initWithApplicationKey:(NSData *)appKey userAgent:(NSString *)userAgent loadingPolicy:(SPAsyncLoadingPolicy)policy error:(NSError *__autoreleasing *)error
{
    // DO NOT INSTANTIATE THAT CLASS ANYWHERE ELSE INSTEAD USE THE SHARED INSTANCE!
    // The initializeSharedInstanceWithApplicationKey:userAgent:loadingPolicy:error: method uses the same method just with an _ as prefix which is a private method.
    return nil;
}

- (id)_initWithApplicationKey:(NSData *)appKey userAgent:(NSString *)userAgent loadingPolicy:(SPAsyncLoadingPolicy)policy error:(NSError *__autoreleasing *)error
{
    self = [super initWithApplicationKey:appKey userAgent:userAgent loadingPolicy:policy error:error];
    return self;
}

+ (dispatch_queue_t)spotifyLocalQueue
{
    static dispatch_queue_t localQueue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        localQueue = dispatch_queue_create("com.indragie.SNRMusicKit.spotifyLocalQueue", DISPATCH_QUEUE_SERIAL);
    });
    return localQueue;
}

@end

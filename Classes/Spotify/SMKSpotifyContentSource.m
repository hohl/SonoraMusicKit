//
//  SMKSpotifyContentSource.m
//  SNRMusicKit
//
//  Created by Indragie Karunaratne on 2012-08-24.
//  Copyright (c) 2012 Indragie Karunaratne. All rights reserved.
//

#import "Spotify.h"
#import "SMKPredicates.h"
#import "SMKSpotifyAuthenticationController.h"
#import "NSObject+SMKSpotifyAdditions.h"
#import "NSMutableArray+SMKAdditions.h"

@interface SMKSpotifyAuthenticationController ()
- (instancetype)_initWithSession:(SPSession<SMKContentSource> *)session;
@end

@interface SMKSpotifyContentSource ()
- (id)_initWithApplicationKey:(NSData *)appKey userAgent:(NSString *)userAgent loadingPolicy:(SPAsyncLoadingPolicy)policy error:(NSError *__autoreleasing *)error;
@end

@implementation SMKSpotifyContentSource {
    SMKSpotifyAuthenticationController *_authenticationController;
}

#pragma mark - SMKContentSource

- (NSString *)name { return @"Spotify"; }

- (NSString *)displayName { return @"Spotify"; }

- (void)fetchPlaylistsWithSortDescriptors:(NSArray *)sortDescriptors
                               predicates:(NSDictionary *)predicates
                        completionHandler:(void(^)(NSArray *playlists, NSError *error))handler
{
    if (!self.user) {
        return handler(nil, SMKSpotifyNotLoggedInError());
    }
    
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
                                                predicates:predicates];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (handler)
                        handler(playlists, nil);
                });
            });
            dispatch_release(group);
        });
    }];
}

- (void)fetchTracksWithSortDescriptors:(NSArray *)sortDescriptors
                            predicates:(NSDictionary *)predicates
                     completionHandler:(void (^)(NSArray *, NSArray *, NSError *))handler
{
    if (!self.user) {
        return handler(nil, nil, SMKSpotifyNotLoggedInError());
    }
    if (!predicates) {
        return handler(nil, nil, nil);
    }
    
    __weak SPSession *weakSelf = self;
    [self SMK_spotifyWaitAsyncThen:^{
        SPSession *strongSelf = weakSelf;
        dispatch_async([SMKSpotifyContentSource spotifyLocalQueue], ^{
            SPSearch *search = [[SPSearch alloc] initWithSearchQuery:[predicates objectForKey:SMKPredicateKeyTitle] inSession:strongSelf];
            [SPAsyncLoading waitUntilLoaded:search timeout:SMKSpotifyDefaultLoadingTimeout then:^(NSArray *loadedItems, NSArray *notLoadedItems) {
                if ([loadedItems containsObject:search]) {
                    handler(search.tracks, nil, nil);
                } else {
                    handler(nil, nil, SMKSpotifyLoadingTimeoutError());
                }
            }];
        });
    }];
}

- (void)fetchAlbumsWithSortDescriptors:(NSArray *)sortDescriptors
                            predicates:(NSDictionary *)predicates
                     completionHandler:(void (^)(NSArray *, NSArray *, NSError *))handler
{
    if (!self.user) {
        return handler(nil, nil, SMKSpotifyNotLoggedInError());
    }
    if (!predicates) {
        return handler(nil, nil, nil);
    }
    
    __weak SPSession *weakSelf = self;
    [self SMK_spotifyWaitAsyncThen:^{
        SPSession *strongSelf = weakSelf;
        dispatch_async([SMKSpotifyContentSource spotifyLocalQueue], ^{
            __block SPSearch *search = [[SPSearch alloc] initWithSearchQuery:[predicates objectForKey:SMKPredicateKeyAlbumTitle] inSession:strongSelf];
            [SPAsyncLoading waitUntilLoaded:search timeout:SMKSpotifyDefaultLoadingTimeout then:^(NSArray *loadedItems, NSArray *notLoadedItems) {
                if ([loadedItems containsObject:search]) {
                    handler(search.albums, nil, nil);
                } else {
                    handler(nil, nil, SMKSpotifyLoadingTimeoutError());
                }
            }];
        });
    }];
}

- (void)fetchArtistsWithSortDescriptors:(NSArray *)sortDescriptors
                             predicates:(NSDictionary *)predicates
                      completionHandler:(void (^)(NSArray *, NSArray *, NSError *))handler
{
    if (!self.user) {
        return handler(nil, nil, SMKSpotifyNotLoggedInError());
    }
    if (!predicates) {
        return handler(nil, nil, nil);
    }
    
    __weak SPSession *weakSelf = self;
    [self SMK_spotifyWaitAsyncThen:^{
        SPSession *strongSelf = weakSelf;
        dispatch_async([SMKSpotifyContentSource spotifyLocalQueue], ^{
            SPSearch *search = [[SPSearch alloc] initWithSearchQuery:[predicates objectForKey:SMKPredicateKeyArtistName] inSession:strongSelf];
            [SPAsyncLoading waitUntilLoaded:search timeout:SMKSpotifyDefaultLoadingTimeout then:^(NSArray *loadedItems, NSArray *notLoadedItems) {
                if ([loadedItems containsObject:search]) {
                    handler(search.artists, nil, nil);
                } else {
                    handler(nil, nil, SMKSpotifyLoadingTimeoutError());
                }
            }];
        });
    }];
}

- (id<SMKAuthenticationController>)authenticationController
{
    if (!_authenticationController) {
        _authenticationController = [[SMKSpotifyAuthenticationController alloc] _initWithSession:self];
    }
    return _authenticationController;
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
    NSLog(@"DO NOT INSTANTIATE 'SMKSpotifyContentSource' CLASS ANYWHERE ELSE INSTEAD USE THE SHARED INSTANCE!");
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

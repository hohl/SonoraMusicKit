//
//  SPArtist+SMKArtist.m
//  SNRMusicKit
//
//  Created by Indragie Karunaratne on 2012-08-24.
//  Copyright (c) 2012 Indragie Karunaratne. All rights reserved.
//

#import "SPArtist+SMKArtist.h"
#import "SMKSpotifyContentSource.h"
#import "NSObject+AssociatedObjects.h"
#import "NSObject+SMKSpotifyAdditions.h"
#import "NSMutableArray+SMKAdditions.h"
#import "SMKSpotifyHelpers.h"

static void* const SMKSPArtistBrowseKey = @"SMK_SPArtistBrowse";

@implementation SPArtist (SMKArtist)

#pragma mark - SMKArtist

- (void)fetchAlbumsWithSortDescriptors:(NSArray *)sortDescriptors
                             predicate:(NSPredicate *)predicate
                     completionHandler:(void(^)(NSArray *albums, NSError *error))handler
{
    SPArtistBrowse *browse = [self SMK_associatedArtistBrowse];
    SPDispatchAsync(^{
        [SPAsyncLoading waitUntilLoaded:browse timeout:SMKSpotifyDefaultLoadingTimeout then:^(NSArray *loadedItems, NSArray *notLoadedItems) {
            if ([loadedItems count] == 0) {
                handler(nil, SMKSpotifyLoadingTimeoutError());
            } else if (predicate) {
                handler([browse.albums filteredArrayUsingPredicate:predicate], nil);
            } else {
                handler(browse.albums, nil);
            }
        }];
    });
}

#pragma mark - SMKContentObject

- (NSString *)uniqueIdentifier
{
    return [self.spotifyURL absoluteString];
}

+ (NSSet *)supportedSortKeys
{
    return [NSSet setWithObjects:@"name", nil];
}

- (id<SMKContentSource>)contentSource
{
    return [SMKSpotifyContentSource sharedInstance];
}

#pragma mark - SMKWebObject

- (NSURL *)webURL
{
    return self.spotifyURL;
}

#pragma mark - SMKHierarchicalLoading

- (void)loadHierarchy:(dispatch_group_t)group array:(NSMutableArray *)array
{
    dispatch_group_enter(group);
    __weak SPArtist *weakSelf = self;
    [self SMK_spotifyWaitAsyncThen:^{
        SPArtist *strongSelf = weakSelf;
        SPArtistBrowse *browse = [strongSelf SMK_associatedArtistBrowse];
        [browse loadHierarchy:group array:array];
        dispatch_group_leave(group);
    }];
}

#pragma mark - SMKArtworkObject

- (void)fetchArtworkWithSize:(SMKArtworkSize)size
       completionHandler:(void(^)(SMKPlatformNativeImage *image, NSError *error))handler
{
    SPArtistBrowse *browse = [self SMK_associatedArtistBrowse];
    [browse SMK_spotifyWaitAsyncThen:^{
        SPImage *image = browse.firstPortrait;
        [image SMK_spotifyWaitAsyncThen:^{
            if (handler) handler(image.image, nil);
        }];
    }];
}

- (SPArtistBrowse *)SMK_associatedArtistBrowse
{
    __block SPArtistBrowse *browse = [self associatedValueForKey:SMKSPArtistBrowseKey];
    if (!browse) {
        browse = [SPArtistBrowse browseArtist:self inSession:self.contentSource type:SP_ARTISTBROWSE_NO_TRACKS];
        [self associateValue:browse withKey:SMKSPArtistBrowseKey];
    }
    return browse;
}
@end

@implementation SPArtistBrowse (SMKArtist)

#pragma mark - SMKHierarchicalLoading

- (void)loadHierarchy:(dispatch_group_t)group array:(NSMutableArray *)array
{
    __weak SPArtistBrowse *weakSelf = self;
    dispatch_group_enter(group);
    [self SMK_spotifyWaitAsyncThen:^{
        SPArtistBrowse *strongSelf = weakSelf;
        [strongSelf.albums enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [obj loadHierarchy:group array:array];
        }];
        dispatch_group_leave(group);
    }];
}
@end

//
//  SMKSpotifyContentSource.h
//  SNRMusicKit
//
//  Created by Indragie Karunaratne on 2012-08-24.
//  Copyright (c) 2012 Indragie Karunaratne. All rights reserved.
//

#import <CocoaLibSpotify/CocoaLibSpotify.h>

#import "SMKContentSource.h"
#import "SPUser+SMKUser.h"
#import "SPPlaylist+SMKPlaylist.h"
#import "SPTrack+SMKTrack.h"
#import "SPAlbum+SMKAlbum.h"
#import "SPArtist+SMKArtist.h"
#import "SMKSpotifyPlayer.h"

@interface SMKSpotifyContentSource : SPSession <SMKContentSource>
+ (SMKSpotifyContentSource *)sharedInstance;
+ (BOOL)initializeSharedInstanceWithApplicationKey:(NSData *)appKey userAgent:(NSString *)userAgent loadingPolicy:(SPAsyncLoadingPolicy)policy error:(NSError *__autoreleasing *)error;
/** This queue is used to sort and filter content before it's returned */
+ (dispatch_queue_t)spotifyLocalQueue;
@end

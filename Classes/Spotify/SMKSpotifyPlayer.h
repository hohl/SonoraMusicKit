//
//  SMKSpotifyPlayer.h
//  SNRMusicKit
//
//  Created by Indragie Karunaratne on 2012-08-25.
//  Copyright (c) 2012 Indragie Karunaratne. All rights reserved.
//

#import <CocoaLibSpotify/CocoaLibSpotify.h>
#import "SMKPlayer.h"
@class SMKSpotifyContentSource;

@interface SMKSpotifyPlayer : NSObject <SMKPlayer>

#pragma mark - SMKPlayer
@property (nonatomic, copy) void (^finishedTrackBlock)(id<SMKPlayer> player, id<SMKTrack> track, NSError *error);
@property (nonatomic, strong, readonly) SPPlaybackManager *audioPlayer;

@property (nonatomic, assign) NSTimeInterval seekTimeInterval;
@property (nonatomic, assign, readonly) NSTimeInterval playbackTime;
@property (nonatomic, assign, readonly) BOOL playing;
@property (nonatomic, assign) float volume;
@property (nonatomic, strong, readonly) id<SMKTrack> currentTrack;

- (id)initWithPlaybackSession:(SMKSpotifyContentSource *)aSession;

// Preloading (SMKPlayer @optional)
@property (nonatomic, strong, readonly) id<SMKTrack> preloadedTrack;
- (void)preloadTrack:(id<SMKTrack>)track completionHandler:(void(^)(NSError *error))handler;
- (id<SMKTrack>)preloadedTrack;
- (void)skipToPreloadedTrack;
@end

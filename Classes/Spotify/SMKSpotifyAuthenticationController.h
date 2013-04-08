//
//  SMKSpotifyAuthenticationController.h
//  SNRMusicKit
//
//  Created by Michael Hohl on 2013-04-08.
//  Copyright (c) 2013 Michael Hohl. All rights reserved.
//

#import "SonoraMusicKit.h"
#import <CocoaLibSpotify/SPSession.h>

@interface SMKSpotifyAuthenticationController : NSObject<SMKAuthenticationController, SPSessionDelegate>

/** @return YES if the user is authenticated. */
@property (readonly, getter=isAuthenticated) BOOL authenticated;

@end
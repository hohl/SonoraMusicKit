//
//  SMKSpotifyConstants.m
//  SNRMusicKit
//
//  Created by Indragie Karunaratne on 2012-08-24.
//  Copyright (c) 2012 Indragie Karunaratne. All rights reserved.
//

#import "SMKSpotifyConstants.h"
#import "SMKErrorCodes.h"
#import "Spotify.h"
#import "NSError+SMKAdditions.h"

NSTimeInterval const SMKSpotifyDefaultLoadingTimeout = 10.0;

NSError *SMKSpotifyLoadingTimeoutError(void)
{
    return [NSError SMK_errorWithCode:SMKContentSourceErrorTimeout
                          description:NSLocalizedString(@"Spotify took too long to respond.", @"NSError description for loading timeout")
                        contentSource:[SMKSpotifyContentSource sharedInstance]];
}

NSError *SMKSpotifyNotLoggedInError(void)
{
    return [NSError SMK_errorWithCode:SMKContentSourceErrorLoginRequired
                          description:NSLocalizedString(@"To use Spotify you need to login with a Premium account!", @"NSError description for loading timeout")
                        contentSource:[SMKSpotifyContentSource sharedInstance]];
}

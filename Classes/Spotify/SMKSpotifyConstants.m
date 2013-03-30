//
//  SMKSpotifyConstants.m
//  SNRMusicKit
//
//  Created by Indragie Karunaratne on 2012-08-24.
//  Copyright (c) 2012 Indragie Karunaratne. All rights reserved.
//

#import "SMKSpotifyConstants.h"

NSString const *SMKSpotifyErrorDomain = @"com.indragie.SNRMusicKit.Spotify";
NSInteger const SMKSpotifyLoadingTimeoutErrorCode = 1;

NSTimeInterval const SMKSpotifyDefaultLoadingTimeout = 10.0;

NSError *SMKSpotifyLoadingTimeoutError(void)
{
    return [NSError errorWithDomain:(NSString *)SMKSpotifyErrorDomain
                               code:SMKSpotifyLoadingTimeoutErrorCode
                           userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"Spotify took too long to respond.", @"NSError description for loading timeout")}];
}
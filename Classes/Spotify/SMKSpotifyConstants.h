//
//  SMKSpotifyConstants.h
//  SNRMusicKit
//
//  Created by Indragie Karunaratne on 2012-08-24.
//  Copyright (c) 2012 Indragie Karunaratne. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString const *SMKSpotifyErrorDomain;

extern NSTimeInterval const SMKSpotifyDefaultLoadingTimeout;
extern NSInteger const SMKSpotifyLoadingTimeoutErrorCode;
NSError *SMKSpotifyLoadingTimeoutError(void);

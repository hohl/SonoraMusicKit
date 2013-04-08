//
//  SMKErrorCodes.h
//  SNRMusicKit
//
//  Created by Indragie Karunaratne on 2012-08-21.
//  Copyright (c) 2012 Indragie Karunaratne. All rights reserved.
//

extern NSString *const SMKDefaultErrorDomain;
extern NSString *const SMKErrorUserInfoKeyContentSource; // <- key used in NSError userInfo for content source

extern NSInteger const SMKPlayerErrorFailedToCreateInputSource;
extern NSInteger const SMKPlayerErrorFailedToCreateDecoder;
extern NSInteger const SMKPlayerErrorFailedToEnqueueTrack;
extern NSInteger const SMKPlayerErrorItemAlreadyExists;
extern NSInteger const SMKPlayerErrorFailedPlayItem;

extern NSInteger const SMKContentSourceErrorLoginRequired;
extern NSInteger const SMKContentSourceErrorTimeout;

extern NSInteger const SMKQueuePlayerErrorOutOfIndex;

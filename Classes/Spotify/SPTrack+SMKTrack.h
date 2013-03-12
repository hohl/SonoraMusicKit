//
//  SPTrack+SMKTrack.h
//  SNRMusicKit
//
//  Created by Indragie Karunaratne on 2012-08-24.
//  Copyright (c) 2012 Indragie Karunaratne. All rights reserved.
//

#import <CocoaLibSpotify/CocoaLibSpotify.h>

#import "SMKTrack.h"
#import "SMKArtworkObject.h"
#import "SMKWebObject.h"
#import "SMKHierarchicalLoading.h"

@interface SPTrack (SMKTrack) <SMKTrack, SMKArtworkObject, SMKWebObject, SMKHierarchicalLoading>
@end

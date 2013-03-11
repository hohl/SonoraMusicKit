//
//  SMKMPMediaArtist.h
//  SNRMusicKit
//
//  Created by Indragie Karunaratne on 2012-08-27.
//  Copyright (c) 2012 Indragie Karunaratne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "SMKArtist.h"
#import "SMKArtworkObject.h"

@interface SMKMPMediaArtist : NSObject <SMKArtist, SMKArtworkObject>
@property (nonatomic, strong, readonly) MPMediaItemCollection *representedObject;
@property (nonatomic, assign, readonly) id<SMKContentSource> contentSource;
@end

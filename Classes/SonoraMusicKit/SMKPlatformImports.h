//
//  SMKPlatformImports.h
//  SNRMusicKit
//
//  Created by Indragie Karunaratne on 2012-08-24.
//  Copyright (c) 2012 Indragie Karunaratne. All rights reserved.
//

#if TARGET_OS_IPHONE
#define SMKPlatformNativeImage UIImage
#else
#define SMKPlatformNativeImage NSImage
#endif
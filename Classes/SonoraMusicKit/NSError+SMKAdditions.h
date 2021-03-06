//
//  NSError+SMKAdditions.h
//  SNRMusicKit
//
//  Created by Indragie Karunaratne on 2012-08-21.
//  Copyright (c) 2012 Indragie Karunaratne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMKContentSource.h"

@interface NSError (SMKAdditions)
/**
 @param code The error code
 @param description The human readable error description
 @return The NSError object created with those parameters
 */
+ (NSError *)SMK_errorWithCode:(NSInteger)code description:(NSString *)description;
/**
 @param code The error code
 @param description The human readable error description
 @param contentSource The content source where the error occurred
 @return The NSError object created with those parameters
 */
+ (NSError *)SMK_errorWithCode:(NSInteger)code description:(NSString *)description contentSource:(id<SMKContentSource>)contentSource;
@end

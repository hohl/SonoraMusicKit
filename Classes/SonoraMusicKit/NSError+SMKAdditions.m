//
//  NSError+SMKAdditions.m
//  SNRMusicKit
//
//  Created by Indragie Karunaratne on 2012-08-21.
//  Copyright (c) 2012 Indragie Karunaratne. All rights reserved.
//

#import "NSError+SMKAdditions.h"
#import "SMKErrorCodes.h"



@implementation NSError (SMKAdditions)
+ (NSError *)SMK_errorWithCode:(NSInteger)code description:(NSString *)description
{
    return [NSError errorWithDomain:SMKDefaultErrorDomain code:code userInfo:@{NSLocalizedDescriptionKey: description}];
}
+ (NSError *)SMK_errorWithCode:(NSInteger)code description:(NSString *)description contentSource:(id<SMKContentSource>)contentSource
{
    return [NSError errorWithDomain:SMKDefaultErrorDomain code:code userInfo:@{NSLocalizedDescriptionKey: description, SMKErrorUserInfoKeyContentSource: contentSource}];
}
@end

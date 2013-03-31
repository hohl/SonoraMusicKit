//
//  SMKSpotifyPredicate.m
//  Pods
//
//  Created by Michael Hohl on 30.03.13.
//
//

#import "SMKSpotifyPredicate.h"

NSString *const SMKSpotifyPredicatePropertyName = @"name";

@implementation SMKSpotifyPredicate

- (id)initWithDictionary:(NSDictionary *)properties
{
    self = [super init];
    if (self) {
        self.properties = properties;
    }
}

+ (SMKSpotifyPredicate *)predicateWithDictionary:(NSDictionary *)properties
{
    return [[SMKSpotifyPredicate alloc] initWithDictionary:properties];
}

@end

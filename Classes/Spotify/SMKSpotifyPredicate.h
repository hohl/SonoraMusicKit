//
//  SMKSpotifyPredicate.h
//  Pods
//
//  Created by Michael Hohl on 30.03.13.
//
//

#import <Foundation/Foundation.h>

/** Key used for searching by name. This may be the most used key. */
extern NSString *const SMKSpotifyPredicatePropertyName;

/**
 This is a wrapper class that contains a NSString which is used to filter Spotify content.
 */
@interface SMKSpotifyPredicate : NSObject
@property (strong) NSDictionary *properties;
- (id)initWithDictionary:(NSDictionary *)properties;
+ (instancetype)predicateWithDictionary:(NSDictionary *)properties;
@end

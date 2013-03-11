//
//  AMKiTunesSearch.h
//  Autoradio
//
//  Created by Michael Hohl on 07.12.12.
//  Copyright (c) 2012 Michael Hohl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

/**
 @abstract   Allows to search iTunes Store for ID of an entity.
 @discussion iOS 6 introduced a way to interact with the App Store from within you app. Poorly it doesn't allow to
             search the store. You can only display it with SKStoreProductViewController. This helper class adds the
             possibillity to search by using the public iTunes Store REST API.
             (Docs: http://www.apple.com/itunes/affiliates/resources/documentation/itunes-store-web-service-search-api.html )
 @author     Michael Hohl
 */
@interface SMKiTunesStoreSearch : AFHTTPClient

/**
 AMKiTunesSearch is just a small helper. Using it as a singleton should be enough.
 */
+ (instancetype)sharedInstance;

/**
 @abstract   Searches the iTunes store and returns an array of dictionaries containing information about the results.
 @discussion Every result has each own NSDictionary representation in the array. The keys of the NSDictionary are exactly
             the same which are used by the iTunes Store Search API.
 @param parameters NSDictionary which contains keys like AMKiTunesParameterTerm or AMKiTuneParameterMedia.
 @param completion the handler called, when the response of the API has been received
*/
- (void)searchWithParameters:(NSDictionary *)parameters completion:(void(^)(NSArray *playlists, NSError *error))handler;

@end

/*
 Possible parameters. For a more detailed description have a look at
 http://www.apple.com/itunes/affiliates/resources/documentation/itunes-store-web-service-search-api.html
 */
extern NSString * const SMKiTunesParameterTerm;
extern NSString * const SMKiTunesParameterCountry;
extern NSString * const SMKiTunesParameterMedia;
extern NSString * const SMKiTunesParameterEntity;
extern NSString * const SMKiTunesParameterLimit;
extern NSString * const SMKiTunesParameterLanguage;

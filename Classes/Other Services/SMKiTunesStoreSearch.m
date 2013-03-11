//
//  AMKiTunesSearch.m
//  Autoradio
//
//  Created by Michael Hohl on 07.12.12.
//  Copyright (c) 2012 Michael Hohl. All rights reserved.
//

#import "SMKiTunesStoreSearch.h"

static NSString* const AMKiTunesSearchBaseURL = @"http://itunes.apple.com/";

@implementation SMKiTunesStoreSearch

+ (instancetype)sharedInstance
{
    static SMKiTunesStoreSearch *client;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        client = [[SMKiTunesStoreSearch alloc] init];
    });
    return client;
}

- (id)init
{
    if ((self = [super initWithBaseURL:[NSURL URLWithString:AMKiTunesSearchBaseURL]])) {
        [self setParameterEncoding:AFJSONParameterEncoding];
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setDefaultHeader:@"Accept" value:@"application/json"];
    }
    return self;
}

- (void)searchWithParameters:(NSDictionary *)parameters completion:(void (^)(NSArray *response, NSError *error))handler
{
    [self getPath:@"search" parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *response) {
        handler([response objectForKey:@"results"], nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        handler(nil, error);
    }];
}

@end

NSString * const SMKiTunesParameterTerm = @"term";
NSString * const SMKiTunesParameterCountry = @"country";
NSString * const SMKiTunesParameterMedia = @"media";
NSString * const SMKiTunesParameterEntity = @"entity";
NSString * const SMKiTunesParameterLimit = @"limit";
NSString * const SMKiTunesParameterLanguage = @"lang";

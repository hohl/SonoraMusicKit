//
//  SMKSpotifyAuthenticationController.h
//  SNRMusicKit
//
//  Created by Michael Hohl on 2013-04-08.
//  Copyright (c) 2013 Michael Hohl. All rights reserved.
//

#import "SMKSpotifyAuthenticationController.h"
#import "Spotify.h"
#import "NSError+SMKAdditions.h"
#import <CocoaLibSpotify/CocoaLibSpotify.h>

@interface SMKSpotifyAuthenticationController ()
- (instancetype)_initWithSession:(SPSession<SMKContentSource> *)session;
@end

@implementation SMKSpotifyAuthenticationController {
    __weak SPSession<SMKContentSource> *_contentSource;
    NSDictionary *_credentials;
}

@synthesize delegate = _delegate;
@synthesize contentSource = _contentSource;

- (void)authenticateWithCredentials:(NSDictionary *)credentials
{
    NSString *userName = [credentials objectForKey:@"UserName"];
    NSString *credential = [credentials objectForKey:@"Credential"];
    
    _credentials = credentials;
    [_contentSource attemptLoginWithUserName:userName existingCredential:credential];
}

#ifdef TARGET_OS_IPHONE
- (UIViewController *)authenticationViewController
{
    SPLoginViewController *loginViewController = [SPLoginViewController loginControllerForSession:_contentSource];
    return loginViewController;
}
#endif

- (instancetype)_initWithSession:(SPSession<SMKContentSource> *)contentSource
{
    self = [super init];
    if (self) {
        _contentSource = contentSource;
        contentSource.delegate = self;
    }
    return self;
}

- (BOOL)isAuthenticated
{
    return _contentSource.user != nil;
}

#pragma mark - SPSessionDelegate

- (void)session:(SPSession *)aSession didGenerateLoginCredentials:(NSString *)credential forUserName:(NSString *)userName
{
    NSMutableDictionary *credentials = [NSMutableDictionary dictionaryWithCapacity:2];
    [credentials setObject:userName forKey:@"UserName"];
    [credentials setObject:credential forKey:@"Credential"];
    _credentials = credentials;
    if ([self.delegate respondsToSelector:@selector(authenticationController:didAuthenticateWithCredentials:)]) {
        [self.delegate authenticationController:self didAuthenticateWithCredentials:_credentials];
    }
}

- (void)session:(SPSession *)aSession didFailToLoginWithError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(authenticationController:didFailToLoginWithError:)]) {
        [self.delegate authenticationController:self didFailToLoginWithError:error];
    }
}

- (void)session:(SPSession *)aSession didEncounterNetworkError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(authenticationController:didEncounterNetworkError:)]) {
        [self.delegate authenticationController:self didEncounterNetworkError:error];
    }
}

- (void)sessionDidLogOut:(SPSession *)aSession
{
    _credentials = nil;
    if ([self.delegate respondsToSelector:@selector(authenticationControllerDidLogout:)]) {
        [self.delegate authenticationControllerDidLogout:self];
    }
}

@end
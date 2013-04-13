//
//  SMKAuthenticationController.h
//  SNRMusicKit
//
//  Created by Michael Hohl on 2013-04-08.
//  Copyright (c) 2013 Michael Hohl. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SMKAuthenticationControllerDelegate;

@protocol SMKAuthenticationController <NSObject>
/** Delegate to react on login and logout events. */
@property (weak) id<SMKAuthenticationControllerDelegate> delegate;

/** Content source which is the authentication controller for. */
@property (weak) id<SMKContentSource> contentSource;

/** @return YES if the user is authenticated. */
- (BOOL)isAuthenticated;

#ifdef TARGET_OS_IPHONE
/**
 Attempts to reauthorize using an access token from a previous session.
 If this process fails the user is presented with a modal login dialog.
 @param credentials which store the username and password or similar information used to login
 @param currentController controller from which a login view might be launched
 @discussion This method is asynchronous and will return immediately.
 */
- (void)authorizeUsingCredentials:(NSDictionary *)credentials fromController:(UIViewController *)currentController;

/**
 Presents a modal login dialog and attempts to get authorized.
 @param currentController controller from which the login view should be launched
 */
- (void)authorizeFromController:(UIViewController *)currentController;
#endif
@end

@protocol SMKAuthenticationControllerDelegate <NSObject>
@optional
/**
 Called when the authentication controller successfully logged in.
 @param controller just a reference to the controller
 @param credentials the credentials used to login
 @discussion You may want to use this to store the credentials to allow automatic relogin on next launch.
 */
- (void)authenticationController:(id<SMKAuthenticationController>)controller didAuthenticateWithCredentials:(NSDictionary *)credentials;

/**
 Called when authentication controller can't successfully log in.
 */
- (void)authenticationController:(id<SMKAuthenticationController>)controller didFailToLoginWithError:(NSError *)error;

/**
 Called when an issue with the network causes an issue with using the content source.
 */
- (void)authenticationController:(id<SMKAuthenticationController>)controller didEncounterNetworkError:(NSError *)error;

/**
 Called when the user got logged out.
 */
- (void)authenticationControllerDidLogout:(id<SMKAuthenticationController>)controller;
@end
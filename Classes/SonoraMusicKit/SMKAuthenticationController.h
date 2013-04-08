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

/** @return YES if the user is authenticated. */
- (BOOL)isAuthenticated;

/**
 This method will authenticate the user with the passed credentials.
 @param credentials the credentials used to store 
 @discussion This method is asynchronous and will return immediately.
 */
- (void)authenticateWithCredentials:(NSDictionary *)credentials
                  completionHandler:(void(^)(NSError *error))handler;

#if TARGET_OS_PHONE
/**
 UIViewController which handles the login procces.
 @discussion After the user logged in via the view controller the delegate method didAuthenticateWithCredentials: will
 get called. You may want to use the delegate method to store the credentials to re-authenticate on next launch.
 */
- (UIViewController *)authenticationViewController;
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
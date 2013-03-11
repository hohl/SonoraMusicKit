//
//  ARMediaSection.h
//  Autoradio
//
//  Created by Michael Hohl on 02.09.12.
//  Copyright (c) 2012 Michael Hohl. All rights reserved.
//

#import <Foundation/Foundation.h>

///
/// A media query section represents a range of media items or media item collections.
/// You can use sections when displaying a query’s items or collections in your app’s user interface.
///
@interface SMKSection : NSObject

// The range in the media query's items or collections array that is represented by the media query section.
@property (nonatomic, assign, readonly) NSRange range;

/// The localized title of the media query section.
@property (nonatomic, copy, readonly) NSString *title;

/// Creates a new ARMediaSection
- (id)initWithTitle:(NSString *)aTitle range:(NSRange)aRange;

@end
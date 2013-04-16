//
//  SMKPredicates.h
//  Sonora Music Kit
//
//  Created by Michael Hohl on 2013-04-16.
//  Copyright (c) 2013 Michael Hohl. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 Sonora Music Kit always uses dictionaries with predicates for filtering content sources.
 The following strings are used as keys for the dictionaries while the objects contain the search term.
 */

/** Key used for searching by title. */
extern NSString *const SMKPredicateKeyTitle;

/** Key used for searching by album name. */
extern NSString *const SMKPredicateKeyAlbumTitle;

/** Key used for searching by artist name. */
extern NSString *const SMKPredicateKeyArtistName;

/** Key used for searching by name. */
extern NSString *const SMKPredicateKeyUniqueIdentifier;

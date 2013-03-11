//
//  ARMediaSection.m
//  Autoradio
//
//  Created by Michael Hohl on 02.09.12.
//  Copyright (c) 2012 Michael Hohl. All rights reserved.
//

#import "SMKSection.h"

@implementation SMKSection

@synthesize range;
@synthesize title;

- (id)initWithTitle:(NSString *)aTitle range:(NSRange)aRange
{
    self = [super init];
    if (self)
    {
        title = [aTitle copy];
        range = aRange;
    }
    return self;
}

@end

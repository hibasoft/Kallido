//
//  Perk.m
//  Kaliido
//
//  Created by Vadim Budnik on 6/28/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import "Perk.h"

@implementation Perk

- (instancetype)initWithID:(NSInteger)Id Name:(NSString*)name Thumbnail:(NSString*)url
{
    self = [super init];
    if (!self)
        return nil;
    
    _perkId = Id;
    _perkName = name;
    _thumbnailURL = url;
    
    return self;
}

@end

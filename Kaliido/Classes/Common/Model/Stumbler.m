//
//  Stumbler.m
//  Kaliido
//
//  Created by Vadim Budnik on 6/29/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import "Stumbler.h"

@implementation Stumbler

- (instancetype)initWithID:(NSInteger)Id Name:(NSString*)name AvatarURL:(NSString*)url
{
    self = [super init];
    if (!self)
        return nil;
    
    _stumblerId = Id;
    _stumblerName = name;
    _avatarURL = url;
    
    return self;
}

@end

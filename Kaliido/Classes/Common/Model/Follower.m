//
//  Follower.m
//  Kaliido
//
//  Created by Vadim Budnik on 6/29/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import "Follower.h"

@implementation Follower

- (instancetype)initWithID:(NSInteger)Id Name:(NSString*)name AvatarURL:(NSString*)url
{
    self = [super init];
    if (!self)
        return nil;
    
    _followerId = Id;
    _followerName = name;
    _avatarURL = url;
    
    return self;
}

@end

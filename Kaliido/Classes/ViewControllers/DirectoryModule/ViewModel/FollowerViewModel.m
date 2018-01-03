//
//  FollowerViewModel.m
//  Kaliido
//
//  Created by Vadim Budnik on 6/29/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import "FollowerViewModel.h"
#import "Follower.h"

@implementation FollowerViewModel

- (instancetype)initWithFollower:(Follower*)follower
{
    self = [super init];
    if (!self) return nil;
    
    _followerName = follower.followerName;
    _avatarURL = follower.avatarURL;
    
    return self;
}

@end

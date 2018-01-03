//
//  FollowersViewModel.m
//  Kaliido
//
//  Created by Phoenix on 6/29/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import "FollowersViewModel.h"

@implementation FollowersViewModel

- (instancetype)initWithFollowers:(NSArray*)followerList
{
    self = [super init];
    if (!self) return nil;
    
    _arFollowers = followerList;
    
    return self;
}

@end

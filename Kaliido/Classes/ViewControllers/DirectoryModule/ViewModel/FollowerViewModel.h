//
//  FollowerViewModel.h
//  Kaliido
//
//  Created by Vadim Budnik on 6/29/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Follower;

@interface FollowerViewModel : NSObject

@property (nonatomic, readonly) NSString *followerName;
@property (nonatomic, readonly) NSString *avatarURL;

- (instancetype)initWithFollower:(Follower*)follower;

@end

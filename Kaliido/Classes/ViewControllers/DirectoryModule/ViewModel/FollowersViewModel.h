//
//  FollowersViewModel.h
//  Kaliido
//
//  Created by Phoenix on 6/29/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FollowersViewModel : NSObject

@property (nonatomic, readonly) NSArray *arFollowers;

- (instancetype)initWithFollowers:(NSArray*)followerList;

@end

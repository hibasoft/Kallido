//
//  KLUsersUtils.h
//  Kaliido
//
//  Created by Daron21.08.14.
//  Copyright (c) 2014 Kaliido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KLUsersUtils : NSObject

+ (NSArray *)sortUsersByFullname:(NSArray *)users;
+ (NSURL *)userAvatarURL:(KLUser *)user;

@end

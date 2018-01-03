//
//  KLUsersUtils.m
//  Kaliido
//
//  Created by Daron21.08.14.
//  Copyright (c) 2014 Kaliido. All rights reserved.
//

#import "KLUsersUtils.h"

@implementation KLUsersUtils

+ (NSArray *)sortUsersByFullname:(NSArray *)users
{    
    NSSortDescriptor *sorter = [[NSSortDescriptor alloc]
                                initWithKey:@"fullName"
                                ascending:YES
                                selector:@selector(localizedCaseInsensitiveCompare:)];
    NSArray *sortedUsers = [users sortedArrayUsingDescriptors:@[sorter]];
    
    return sortedUsers;
}

+ (NSURL *)userAvatarURL:(KLUser *)user {
    NSURL *url = nil;
#warning Old avatar url logic changed!
    if (user.photoUID) {
        url = [NSURL URLWithString:user.photoUID];
    } else if (user.avatarURL) {
        url = [NSURL URLWithString:user.avatarURL];
    }else{
        url = [NSURL URLWithString:user.website];
    }
    return url;
}

@end

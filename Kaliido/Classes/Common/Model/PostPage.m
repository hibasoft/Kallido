//
//  PostPage.m
//  Kaliido
//
//  Created by Vadim Budnik on 7/1/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import "PostPage.h"

@implementation PostPage

- (instancetype)initWithID:(NSInteger)Id Comment:(NSString*)comment CreatedAt:(NSString*)createdAt UpdatedAt:(NSString*)updatedAt UserID:(NSInteger)userId UserName:(NSString*)userName AvatarURL:(NSString*)url
{
    self = [super init];
    if (!self)
        return nil;
    
    _pageId = Id;
    _comment = comment;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    
    _userId = userId;
    _userName = userName;
    _userAvatarURL = url;
    
    return self;
}

@end

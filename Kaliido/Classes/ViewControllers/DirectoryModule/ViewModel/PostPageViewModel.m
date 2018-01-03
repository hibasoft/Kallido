//
//  PostPageViewModel.m
//  Kaliido
//
//  Created by Vadim Budnik on 7/1/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import "PostPageViewModel.h"
#import "PostPage.h"

@implementation PostPageViewModel

- (instancetype)initWithPostPage:(PostPage*)postPage
{
    self = [super init];
    if (!self)
        return nil;
    
    _pageId = postPage.pageId;
    _comment = postPage.comment;
    _postedAt = [SharedManager getTimeFrom:postPage.updatedAt];
    
    _userId = postPage.userId;
    _userName = postPage.userName;
    _userAvatarURL = postPage.userAvatarURL;
    
    return self;
}

@end

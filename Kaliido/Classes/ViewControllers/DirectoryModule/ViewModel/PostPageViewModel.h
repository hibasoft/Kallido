//
//  PostPageViewModel.h
//  Kaliido
//
//  Created by Vadim Budnik on 7/1/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PostPage;

@interface PostPageViewModel : NSObject

@property (nonatomic, readonly) NSInteger pageId;
@property (nonatomic, readonly) NSString *comment;
@property (nonatomic, readonly) NSString *postedAt;

@property (nonatomic, readonly) NSInteger userId;
@property (nonatomic, readonly) NSString *userName;
@property (nonatomic, readonly) NSString *userAvatarURL;

- (instancetype)initWithPostPage:(PostPage*)postPage;

@end

//
//  PostPage.h
//  Kaliido
//
//  Created by Vadim Budnik on 7/1/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostPage : NSObject

@property (nonatomic, assign) NSInteger pageId;
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSString *updatedAt;

@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userAvatarURL;

- (instancetype)initWithID:(NSInteger)Id Comment:(NSString*)comment CreatedAt:(NSString*)createdAt UpdatedAt:(NSString*)updatedAt UserID:(NSInteger)userId UserName:(NSString*)userName AvatarURL:(NSString*)url;

@end

//
//  Stumbler.h
//  Kaliido
//
//  Created by Vadim Budnik on 6/29/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stumbler : NSObject

@property (nonatomic, assign) NSInteger stumblerId;
@property (nonatomic, strong) NSString *stumblerName;
@property (nonatomic, strong) NSString *avatarURL;

- (instancetype)initWithID:(NSInteger)Id Name:(NSString*)name AvatarURL:(NSString*)url;

@end

//
//  Directory.m
//  Kaliido
//
//  Created by Vadim Budnik on 6/23/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import "Directory.h"

@implementation Directory

- (instancetype)initWithID:(NSInteger)Id Name:(NSString*)name Headline:(NSString*)headline Location:(NSString*)location PhoneNo:(NSString*)phoneNo Description:(NSString*)desc Type:(NSInteger)type LogoURL:(NSString*)logoUrl CoverURL:(NSString*)coverUrl ProfileURL:(NSString*)profileUrl;
{
    self = [super init];
    if (!self)
        return nil;
    
    _directoryId = Id;
    _directoryName = name;
    _directoryHeadline = headline;
    _directoryLocation = location;
    _directoryPhoneNo = phoneNo;
    _directoryDescription = desc;
    _directoryType = type;
    _logoURL = logoUrl;
    _coverImageURL = coverUrl;
    _profileImageURL = profileUrl;
    
    return self;
}

@end

//
//  DirectoryViewModel.m
//  Kaliido
//
//  Created by Vadim Budnik on 6/23/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import "DirectoryViewModel.h"
#import "Directory.h"

@implementation DirectoryViewModel

- (instancetype)initWithDirectory:(Directory*)directory
{
    self = [super init];
    if (!self) return nil;
    
    _directoryId = directory.directoryId;
    _directoryName = directory.directoryName;
    _directoryHeadline = directory.directoryHeadline;
    _directoryLocation = directory.directoryLocation;
    _directoryPhoneNo = directory.directoryPhoneNo;
    _directoryDescription = directory.directoryDescription;
    _directoryType = directory.directoryType;
    _logoURL = directory.logoURL;
    _coverImageURL = directory.coverImageURL;
    _profileImageURL = directory.profileImageURL;
    
    return self;
}

@end

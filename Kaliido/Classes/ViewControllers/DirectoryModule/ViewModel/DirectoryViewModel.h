//
//  DirectoryViewModel.h
//  Kaliido
//
//  Created by Vadim Budnik on 6/23/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Directory;

@interface DirectoryViewModel : NSObject

@property (nonatomic, readwrite) NSInteger directoryId;
@property (nonatomic, readwrite) NSString *directoryName;
@property (nonatomic, readwrite) NSString *directoryHeadline;
@property (nonatomic, readwrite) NSString *directoryLocation;
@property (nonatomic, readwrite) NSString *directoryPhoneNo;
@property (nonatomic, readwrite) NSString *directoryDescription;
@property (nonatomic, readwrite) NSInteger directoryType;
@property (nonatomic, readwrite) NSString *logoURL;
@property (nonatomic, readwrite) NSString *coverImageURL;
@property (nonatomic, readwrite) NSString *profileImageURL;

- (instancetype)initWithDirectory:(Directory*)directory;

@end

//
//  Directory.h
//  Kaliido
//
//  Created by Vadim Budnik on 6/23/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Directory : NSObject

@property (nonatomic, assign) NSInteger directoryId;
@property (nonatomic, strong) NSString *directoryName;
@property (nonatomic, strong) NSString *directoryHeadline;
@property (nonatomic, strong) NSString *directoryLocation;
@property (nonatomic, strong) NSString *directoryPhoneNo;
@property (nonatomic, strong) NSString *directoryDescription;
@property (nonatomic, assign) NSInteger directoryType;
@property (nonatomic, strong) NSString *logoURL;
@property (nonatomic, strong) NSString *coverImageURL;
@property (nonatomic, strong) NSString *profileImageURL;

- (instancetype)initWithID:(NSInteger)Id Name:(NSString*)name Headline:(NSString*)headline Location:(NSString*)location PhoneNo:(NSString*)phoneNo Description:(NSString*)desc Type:(NSInteger)type LogoURL:(NSString*)logoUrl CoverURL:(NSString*)coverUrl ProfileURL:(NSString*)profileUrl;

@end

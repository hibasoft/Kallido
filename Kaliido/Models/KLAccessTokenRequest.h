//
//  KLAccessTokenRequest.h
//  Kaliido
//
//  Created by Robbie Tapping on 9/08/2015.
//  Copyright (c) 2015 Kaliido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KLAccessTokenRequest : NSObject

@property (nonatomic, strong) NSString *password;

@property (nonatomic, strong) NSString *username;

@property (nonatomic, strong) NSString *granttype;

@property (nonatomic, strong) NSString *clientid;

@end

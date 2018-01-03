//
//  KLUserRegistration.h
//  Kaliido
//
//  Created by Robbie Tapping on 8/08/2015.
//  Copyright (c) 2015 Kaliido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KLUserRegistration : NSObject

@property (nonatomic, strong) NSString *fullname;

@property (nonatomic, strong) NSString *password;

@property (nonatomic, strong) NSString *email;

@property (nonatomic, strong) NSString *confirmPassword;

@property (nonatomic, strong) NSString *quickBloxUserId;

+ (NSDictionary*) elementToPropertyMappings;

@end



//
//  KLUserRegistration.m
//  Kaliido
//
//  Created by Robbie Tapping on 8/08/2015.
//  Copyright (c) 2015 Kaliido. All rights reserved.
//

#import "KLUserRegistration.h"


@implementation KLUserRegistration

+ (NSDictionary*) elementToPropertyMappings{
    return @{@"fullname":@"fullname",
             @"password":@"password",
             @"confirmPassword":@"confirmPassword",
             @"email":@"email",
             @"quickBloxUserId":@"quickBloxUserId",};
}
@end

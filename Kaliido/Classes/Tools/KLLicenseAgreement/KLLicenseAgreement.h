//
//  KLLicenseAgreement.h
//  Kaliido
//
//  Created by Daron on 26.08.14.
//  Copyright (c) 2014 Kaliido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KLLicenseAgreement : NSObject

+ (void)checkAcceptedUserAgreementInViewController:(UIViewController *)vc completion:(void(^)(BOOL success))completion;

@end

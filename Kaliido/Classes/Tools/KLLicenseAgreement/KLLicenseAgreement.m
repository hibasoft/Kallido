//
//  KLLicenseAgreement.m
//  Kaliido
//
//  Created by Daron on 26.08.14.
//  Copyright (c) 2014 Kaliido. All rights reserved.
//

#import "KLLicenseAgreement.h"
#import "KLApi.h"
#import "KLSettingsManager.h"
#import "LicenseAgreementViewController.h"

@implementation KLLicenseAgreement

+ (void)checkAcceptedUserAgreementInViewController:(UIViewController *)vc completion:(void(^)(BOOL success))completion {
    
    BOOL licenceAccepted = [[KLApi instance].settingsManager userAgreementAccepted];
    
    if (licenceAccepted) {
        
        if (completion) completion(YES);
    }
    else {
        
        LicenseAgreementViewController *licenceController =
        [vc.storyboard instantiateViewControllerWithIdentifier:@"LicenceAgreementControllerID"];
        
        licenceController.licenceCompletionBlock = completion;
        
        UINavigationController *navViewController =
        [[UINavigationController alloc] initWithRootViewController:licenceController];
        
        [vc presentViewController:navViewController
                         animated:YES
                       completion:nil];
    }
}

@end

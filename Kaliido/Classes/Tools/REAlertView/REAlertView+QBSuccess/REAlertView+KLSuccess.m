//
//  REAlertView+KLSuccess.m
//  Kaliido
//
//  Created by Daron on 30.06.14.
//  Copyright (c) 2014 Kaliido. All rights reserved.
//

#import "REAlertView+KLSuccess.h"

@implementation REAlertView (KLSuccess)

+ (void)showAlertWithMessage:(NSString *)messageString actionSuccess:(BOOL)success {
    
    [REAlertView presentAlertViewWithConfiguration:^(REAlertView *alertView) {
        alertView.title = success ? NSLocalizedString(@"KL_STR_SUCCESS", nil) : NSLocalizedString(@"KL_STR_ERROR", nil);
        alertView.message = messageString;
        [alertView addButtonWithTitle:NSLocalizedString(@"KL_STR_OK", nil) andActionBlock:^{}];
    }];
}

@end

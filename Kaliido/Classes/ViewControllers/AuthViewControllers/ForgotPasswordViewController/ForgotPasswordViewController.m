//
//  ForgotPasswordViewController.m
//  Kaliido
//
//  Created by Daron on 30.06.14.
//  Copyright (c) 2014 Kaliido. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "KLApi.h"

#import "REAlertView+KLSuccess.h"
#import "KLAuthWebService.h"

@interface ForgotPasswordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIButton *resetPasswordBtn;

@end

@implementation ForgotPasswordViewController

- (void) viewDidLoad
{
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)dealloc {
    NSLog(@"%@ - %@",  NSStringFromSelector(_cmd), self);
}
#pragma mark - actions

- (IBAction)pressResetPasswordBtn:(id)sender {
    
    NSString *email = self.emailTextField.text;
    
    if (email.length > 0) {
        [self resetPasswordForMail:email];
    } else {
        [REAlertView showAlertWithMessage:NSLocalizedString(@"KL_STR_EMAIL_FIELD_IS_EMPTY", nil) actionSuccess:NO];
    }
    
}

- (void)resetPasswordForMail:(NSString *)emailString {
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];

    [[KLAuthWebService getInstance] resetPassword:emailString withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        [SVProgressHUD dismiss];
        if (success) {
            [REAlertView showAlertWithMessage:NSLocalizedString(@"KL_STR_MESSAGE_WAS_SENT_TO_YOUR_EMAIL", nil) actionSuccess:YES];
        }else {
            [REAlertView showAlertWithMessage:NSLocalizedString(@"KL_STR_USER_WITH_EMAIL_WASNT_FOUND", nil) actionSuccess:NO];
        }
    }];
    
}

- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end

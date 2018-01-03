//
//  ChangePasswordVC.m
//  Kaliido
//
//  Created by Daron on 24.06.14.
//  Copyright (c) 2014 Kaliido. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "KLSettingsManager.h"
#import "REAlertView+KLSuccess.h"
#import "UIImage+TintColor.h"

#import "KLApi.h"

const NSUInteger kMinPasswordLenght = 7;

@interface ChangePasswordVC ()

<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *oldPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *changeButton;
@property (strong, nonatomic) KLSettingsManager *settingsManager;

@end

@implementation ChangePasswordVC

- (void)dealloc {
    NSLog(@"%@ - %@",  NSStringFromSelector(_cmd), self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.changeButton.layer.cornerRadius = 5.0f;
    
    self.settingsManager = [[KLSettingsManager alloc] init];
    
    [self configureChangePasswordVC];
}

- (void)configureChangePasswordVC {
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    UIImage *buttonBG = [UIImage imageNamed:@"blue_conter"];
    UIColor *normalColor = [UIColor colorWithRed:0.091 green:0.674 blue:0.174 alpha:1.000];
    UIEdgeInsets imgInsets = UIEdgeInsetsMake(9, 9, 9, 9);
    [self.changeButton setBackgroundImage:[buttonBG tintImageWithColor:normalColor resizableImageWithCapInsets:imgInsets]
                                 forState:UIControlStateNormal];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.oldPasswordTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - actions

- (IBAction)pressChangeButton:(id)sender {
    
    NSString *oldPassword = self.settingsManager.password;
    NSString *confirmOldPassword = self.oldPasswordTextField.text;
    NSString *newPassword = self.passwordTextField.text;
    
    if (newPassword.length == 0 || confirmOldPassword.length == 0){
        
        [REAlertView showAlertWithMessage:NSLocalizedString(@"KL_STR_FILL_IN_ALL_THE_FIELDS", nil) actionSuccess:NO];
    }
    else if (newPassword.length < kMinPasswordLenght) {
        
        [REAlertView showAlertWithMessage:NSLocalizedString(@"KL_STR_PASSWORD_IS_TOO_SHORT", nil) actionSuccess:NO];
    }
    else if (![oldPassword isEqualToString:confirmOldPassword]) {
        
        [REAlertView showAlertWithMessage:NSLocalizedString(@"KL_STR_WRONG_OLD_PASSWORD", nil) actionSuccess:NO];
    }
    else {
        
        [self updatePassword:oldPassword newPassword:newPassword];
    }
}

- (void)updatePassword:(NSString *)oldPassword newPassword:(NSString *)newPassword {

    KLUser *myProfile = KLUser.currentUser;
    myProfile.password = newPassword;
    myProfile.oldPassword = oldPassword;
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];

    __weak __typeof(self)weakSelf = self;
//    [[KLApi instance] changePasswordForCurrentUser:myProfile completion:^(BOOL success) {
//        
//        if (success) {
    
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"KL_STR_PASSWORD_CHANGED", nil)];
            [weakSelf.navigationController popViewControllerAnimated:YES];
//        }
    
//    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.oldPasswordTextField) {
        [self.passwordTextField becomeFirstResponder];
    } else if (textField == self.passwordTextField) {
        [self pressChangeButton:nil];
    }
    
    return YES;
}

@end

//
//  KLLicenseAgreementViewController.m
//  Kaliido
//
//  Created by Daron10/07/2014.
//  Copyright (c) 2014 Kaliido. All rights reserved.
//

#import "LicenseAgreementViewController.h"
#import "SVProgressHUD.h"
#import "REAlertView.h"
#import "KLApi.h"
#import "KLSettingsManager.h"

NSString *const kKLAgreementUrl = @"http://Kaliido.com/agreement";

@interface LicenseAgreementViewController ()

<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *acceptButton;

@end

@implementation LicenseAgreementViewController

- (void)dealloc {
    NSLog(@"%@ - %@",  NSStringFromSelector(_cmd), self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.048 green:0.361 blue:0.606 alpha:1.000];
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    BOOL licenceAccepted = [[KLApi instance].settingsManager userAgreementAccepted];
    if (licenceAccepted) {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
//    [SVProgressHUD show];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:kKLAgreementUrl]];
//    [self.webView loadRequest:request];
}

- (IBAction)done:(id)sender {
    [self dismissViewControllerSuccess:NO];
}

- (void)dismissViewControllerSuccess:(BOOL)success {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        if(self.licenceCompletionBlock) {
            
            self.licenceCompletionBlock(success);
            self.licenceCompletionBlock = nil;
        }
    }];
}

- (IBAction)acceptLicense:(id)sender {
    
    [[KLApi instance].settingsManager setUserAgreementAccepted:YES];
    [self dismissViewControllerSuccess:YES];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [SVProgressHUD dismiss];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [SVProgressHUD showErrorWithStatus:error.localizedDescription];
}

@end

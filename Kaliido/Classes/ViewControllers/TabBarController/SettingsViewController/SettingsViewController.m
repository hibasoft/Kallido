//
//  SettingsViewController.m
//  Kaliido
//
//  Created by Daron06/03/2014.
//  Copyright (c) 2014 Kaliido. All rights reserved.
//

#import "SettingsViewController.h"
#import "REAlertView+KLSuccess.h"

#import "SDWebImageManager.h"
#import "KLApi.h"
#import "KLSettingsManager.h"
#import "UIViewController+ECSlidingViewController.h"
#import "AppDelegate.h"
#import "KLXMPPTool.h"
#import "KLSwitch.h"
@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet UITableViewCell *logoutCell;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *changePasswordCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *profileCell;

@property (weak, nonatomic) IBOutlet UILabel *cacheSize;
@property (weak, nonatomic) IBOutlet KLSwitch* pushNotificationSwitch;
@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pushNotificationSwitch.on = [KLApi instance].settingsManager.pushNotificationsEnabled;
    if ([KLApi instance].settingsManager.accountType == KLAccountTypeFacebook) {
        [self cell:self.changePasswordCell setHidden:YES];
    }
    
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:kSettingsCellBundleVersion];
    self.versionLabel.text = appVersion;
    
    self.pushNotificationSwitch.on = true;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    __weak __typeof(self)weakSelf = self;
    [[[SDWebImageManager sharedManager] imageCache] calculateSizeWithCompletionBlock:^(NSUInteger fileCount, NSUInteger totalSize) {
        weakSelf.cacheSize.text = [NSString stringWithFormat:@"Cache size: %.2f mb", (float)totalSize / 1024.f / 1024.f];
    }];
}


- (IBAction) actionMenu:(id)sender
{
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}

- (IBAction) actionChart:(id)sender
{
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    UITabBarController *controller = (UITabBarController*) delegate.viewControllerTabbar;
    self.slidingViewController.topViewController = controller;
    [controller setSelectedIndex:0];
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
    
}

#pragma mark - Actions

- (IBAction)changePushNotificationValue:(UISwitch *)sender {

    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    if (sender.on) {
        [[KLApi instance] subscribeToPushNotificationsForceSettings:YES complete:^(BOOL success) {
            [SVProgressHUD dismiss];
        }];
    }
    else {
        [[KLApi instance] unSubscribeToPushNotifications:^(BOOL success) {
            [SVProgressHUD dismiss];
        }];
    }
    
}

- (IBAction)pressClearCache:(id)sender {
    __weak __typeof(self)weakSelf = self;
    if (sender == nil)
    {
        [[[SDWebImageManager sharedManager] imageCache] clearMemory];
        [[[SDWebImageManager sharedManager] imageCache] clearDiskOnCompletion:^{
            
            [[[SDWebImageManager sharedManager] imageCache] calculateSizeWithCompletionBlock:^(NSUInteger fileCount, NSUInteger totalSize) {
                weakSelf.cacheSize.text = [NSString stringWithFormat:@"Cache size: %.2f mb", (float)totalSize / 1024.f / 1024.f];
            }];
        }];
        return;
    }
    
    [REAlertView presentAlertViewWithConfiguration:^(REAlertView *alertView) {
        
        alertView.message = NSLocalizedString(@"KL_STR_ARE_YOU_SURE", nil);
        [alertView addButtonWithTitle:NSLocalizedString(@"KL_STR_OK", nil) andActionBlock:^{
            
            [[[SDWebImageManager sharedManager] imageCache] clearMemory];
            [[[SDWebImageManager sharedManager] imageCache] clearDiskOnCompletion:^{
                
                [[[SDWebImageManager sharedManager] imageCache] calculateSizeWithCompletionBlock:^(NSUInteger fileCount, NSUInteger totalSize) {
                    weakSelf.cacheSize.text = [NSString stringWithFormat:@"Cache size: %.2f mb", (float)totalSize / 1024.f / 1024.f];
                }];
            }];
        }];
        
        [alertView addButtonWithTitle:NSLocalizedString(@"KL_STR_CANCEL", nil) andActionBlock:^{}];
    }];
}


- (IBAction)logout:(id)sender{
    
    __weak __typeof(self)weakSelf = self;
    [REAlertView presentAlertViewWithConfiguration:^(REAlertView *alertView) {
        
        alertView.message = NSLocalizedString(@"KL_STR_ARE_YOU_SURE", nil);
        [alertView addButtonWithTitle:NSLocalizedString(@"KL_STR_LOGOUT", nil) andActionBlock:^{
            
            [weakSelf pressClearCache:nil];
            [SVProgressHUD  showWithMaskType:SVProgressHUDMaskTypeClear];
            [[KLApi instance] logout:^(BOOL success) {
                [[KLXMPPTool sharedInstance] disconnectXMPP];
                [SVProgressHUD dismiss];
                [weakSelf performSegueWithIdentifier:kSplashSegueIdentifier sender:nil];
            }];
        }];
        
        [alertView addButtonWithTitle:NSLocalizedString(@"KL_STR_CANCEL", nil) andActionBlock:^{}];
    }];
}

@end

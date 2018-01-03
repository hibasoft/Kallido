//
//  KLSplashViewController.m
//  Kaliido
//
//  Created by lysenko.mykhayl on 3/24/14.
//  Copyright (c) 2014 Kaliido. All rights reserved.
//

#import "SplashViewController.h"
#import "WelcomeScreenViewController.h"
#import "KLSettingsManager.h"
#import "REAlertView+KLSuccess.h"
#import "KLApi.h"
#import "KLAuthWebService.h"
#import "KLWebService.h"
#import "AppDelegate.h"
#import "ECSlidingViewController.h"

@interface SplashViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *splashLogoView;
@property (weak, nonatomic) IBOutlet UIButton *reconnectBtn;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation SplashViewController

- (void)dealloc {
    NSLog(@"%@ - %@",  NSStringFromSelector(_cmd), self);
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.splashLogoView setImage:[UIImage imageNamed:IS_HEIGHT_GTE_568 ? @"bg" : @"splash-960"]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self createSession];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)createSession {
    
    self.reconnectBtn.alpha = 0;
    [self.activityIndicator startAnimating];

    __weak __typeof(self)weakSelf = self;
  
    
    
    KLSettingsManager *settingsManager = [[KLSettingsManager alloc] init];
    BOOL rememberMe = settingsManager.rememberMe;
    
    if (rememberMe) {
        
        [[KLApi instance] autoLogin:^(BOOL success) {
            if (!success) {
                
                [[KLApi instance] logout:^(BOOL logoutSuccess) {
                    [weakSelf performSegueWithIdentifier:kWelcomeScreenSegueIdentifier sender:nil];
                }];
                
            }else {
                KLUser *usr = KLUser.currentUser;
                [[KLWebService getInstance] getProfile:[KLAuthWebService getInstance].accessToken withCallback:^(BOOL succ, NSDictionary *response, NSError *error) {
                    [usr setUser:response];
                    [weakSelf performSegueWithIdentifier:kTabBarSegueIdnetifier sender:nil];
                }];
            }
        }];
    } else {
        [weakSelf performSegueWithIdentifier:kWelcomeScreenSegueIdentifier sender:nil];
    }


}

- (void)reconnect {
     [self createSession];
    //self.reconnectBtn.alpha = 1;
    //[self.activityIndicator stopAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)pressReconnectBtn:(id)sender {
    [self createSession];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:kTabBarSegueIdnetifier])
    {
        ECSlidingViewController *vc = [segue destinationViewController];
        UITabBarController *tabVC = (UITabBarController*)vc.topViewController;
        [tabVC setSelectedIndex:0];
    }
}
@end

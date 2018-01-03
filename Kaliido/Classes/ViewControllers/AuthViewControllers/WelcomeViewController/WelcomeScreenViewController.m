//
//  SplashControllerViewController.m
//  Kaliido
//
//  Created by Daron13/02/2014.
//  Copyright (c) 2014 Kaliido. All rights reserved.
//

#import "WelcomeScreenViewController.h"
#import "KLLicenseAgreement.h"
#import "SplashViewController.h"
#import "KLApi.h"
#import "KLSettingsManager.h"

#import "REAlertView.h"
#import "REAlertView+KLSuccess.h"
#import "KLWebService.h"
#import "KLAuthWebService.h"
#import "WelcomeViewController.h"
#import "MainNavController.h"

@interface WelcomeScreenViewController ()
{
    AVAsset *avAsset;
    AVPlayerItem *avPlayerItem;
    AVPlayer     *avPlayer;
    AVPlayerLayer *avPlayerLayer;
}
@property (weak, nonatomic) IBOutlet UIImageView *bubleImage;

- (IBAction)connectWithFacebook:(id)sender;

@end

@implementation WelcomeScreenViewController

- (void)dealloc {
    NSLog(@"%@ - %@",  NSStringFromSelector(_cmd), self);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.bubleImage.image = [UIImage imageNamed:IS_HEIGHT_GTE_568 ? @"logo_big" : @"logo_big_960"];
    [[KLApi instance].settingsManager defaultSettings];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [super viewWillAppear:animated];
//    [avPlayer play];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


#pragma mark - Actions

- (IBAction)connectWithFacebook:(id)sender {
    
    __weak __typeof(self)weakSelf = self;
    [KLLicenseAgreement checkAcceptedUserAgreementInViewController:self completion:^(BOOL success) {
        if (success) {
            [weakSelf signInWithFacebook];
        }
    }];
}

- (IBAction)connectWithTwitter:(id)sender {
    __weak __typeof(self)weakSelf = self;
    [KLLicenseAgreement checkAcceptedUserAgreementInViewController:self completion:^(BOOL success) {
        if (success) {
            [weakSelf signInWithTwitter];
        }
    }];
}

- (IBAction)signUpWithEmail:(id)sender
{
    [self performSegueWithIdentifier:kSignUpSegueIdentifier sender:nil];
}

- (IBAction)pressAlreadyBtn:(id)sender
{
    [self performSegueWithIdentifier:kLogInSegueSegueIdentifier sender:nil];
}

- (void)signInWithFacebook {
    
    
    __weak __typeof(self)weakSelf = self;
    [[KLApi instance] startServices];
    [[KLApi instance] singUpAndLoginWithFacebook:^(BOOL success) {
        
        if (success) {
            
            
                [[KLWebService getInstance] getProfile:[KLAuthWebService getInstance].accessToken withCallback:^(BOOL succ, NSDictionary *response, NSError *err) {
                    [KLUser.currentUser setUser:response];
                    
                    NSString* ejabberdUserId = [NSString stringWithFormat:@"%@",  [response objectForKey:@"quickbloxUserId"]];
                    [[KLXMPPTool sharedInstance] loginWithJID:[XMPPJID jidWithUser:ejabberdUserId domain:@"klsocial.404la.be" resource:@"Kaliido-App-iOSv1.0"] andPassword:ejabberdUserId];
                    
                    [SVProgressHUD dismiss];
                    [weakSelf performSegueWithIdentifier:kTabBarSegueIdnetifier sender:nil];
                    
                }];
        } else {
            [[KLApi instance] logout:^(BOOL logoutSuccess) {
                [SVProgressHUD dismiss];
                [REAlertView showAlertWithMessage:NSLocalizedString(@"KL_STR_FACEBOOK_LOGIN_FALED_ALERT_TEXT", nil) actionSuccess:NO];
            }];
        }
    }];
}


- (void)signInWithTwitter {
    
    
    
}

- (void) presentWelcomeViewController{
    WelcomeViewController *viewController =
    [self.storyboard instantiateViewControllerWithIdentifier:@"WelcomeViewController"];
    
    MainNavController *navViewController =
    [[MainNavController alloc] initWithRootViewController:viewController];
    
    [self presentViewController:navViewController
                       animated:NO
                     completion:nil];
}
@end

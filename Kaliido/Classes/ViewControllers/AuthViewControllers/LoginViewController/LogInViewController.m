//
//  KLLogInViewController.m
//  Kaliido
//
//  Created by Daron13/02/2014.
//  Copyright (c) 2014 Kaliido. All rights reserved.
//

#import "LogInViewController.h"
#import "WelcomeScreenViewController.h"
#import "KLLicenseAgreement.h"
#import "KLSettingsManager.h"
#import "REAlertView+KLSuccess.h"
#import "KLApi.h"

//#import "KLAuthWebService.h"
#import "KLWebService.h"
#import "AppDelegate.h"
#import "ECSlidingViewController.h"
#import "WelcomeViewController.h"

@interface LogInViewController ()
{
    IBOutlet UIView *viewKeyboardContainer;
    float origPt;
}
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) KLSettingsManager *settingsManager;
@property (weak, nonatomic) IBOutlet UIButton *btnRemember;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *keyboardContainerTopConstraint;

@end

@implementation LogInViewController

- (void)dealloc {
    NSLog(@"%@ - %@",  NSStringFromSelector(_cmd), self);
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    //[self.navigationController setNavigationBarHidden:NO animated:YES];
    self.btnRemember.selected = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    origPt = self.keyboardContainerTopConstraint.constant;
//    viewKeyboardContainer.translatesAutoresizingMaskIntoConstraints = YES;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:kLOGIN_SUCCESS object:nil];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)keyboardDidShow: (NSNotification *) notif{
    self.keyboardContainerTopConstraint.constant = origPt - 100;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
    
}
    
- (void)keyboardDidHide: (NSNotification *) notif{
    self.keyboardContainerTopConstraint.constant = origPt;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [super viewWillAppear:animated];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - Actions

- (IBAction)hideKeyboard:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)logIn:(id)sender
{
    NSString *email = self.emailField.text;
    NSString *password = self.passwordField.text;
    
    if (email.length == 0 || password.length == 0) {
        [REAlertView showAlertWithMessage:NSLocalizedString(@"KL_STR_FILL_IN_ALL_THE_FIELDS", nil)
                            actionSuccess:NO];
    }
    else {
       
        NSLog(@"loginSuccess");
        
        
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        [[KLApi instance] startServices];
        
        [[KLApi instance] loginWithEmail:email
                                password:password
                              rememberMe:self.btnRemember.selected
                              completion:^(BOOL success)
         {
             if (success) {
                 
                 
                 
                 
                 
                 [[KLApi instance] setAutoLogin:self.btnRemember.selected
                                withAccountType:KLAccountTypeEmail];
                 
                 KLUser *usr = KLUser.currentUser;
                 [[KLWebService getInstance] getProfile:[KLAuthWebService getInstance].accessToken withCallback:^(BOOL succ, NSDictionary *response, NSError *error) {
                     [SVProgressHUD dismiss];
                     [usr setUser:response];
                     [self performSegueWithIdentifier:kTabBarSegueIdnetifier sender:nil];
                 }];
             }else
             {
                 [SVProgressHUD dismiss];
                 [[KLApi instance] logout:^(BOOL logoutSuccess) {
                     [REAlertView showAlertWithMessage:@"The account details entered where incorrect." actionSuccess:NO];
                 }];
             }
         }];
        
    }
    
}

- (IBAction)connectWithFacebook:(id)sender
{
    __weak __typeof(self)weakSelf = self;
    [KLLicenseAgreement checkAcceptedUserAgreementInViewController:self completion:^(BOOL success) {
        if (success) {
            [weakSelf fireConnectWithFacebook];
        }
    }];
}

- (void)fireConnectWithFacebook
{
    __weak __typeof(self)weakSelf = self;
    
    
        
    [[KLApi instance] singUpAndLoginWithFacebook:^(BOOL success) {
        
        if (success) {
                [[KLWebService getInstance] getProfile:[KLAuthWebService getInstance].accessToken withCallback:^(BOOL succ, NSDictionary *response, NSError *error) {
                    NSLog(@"%@", response);
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
- (IBAction) actionRemember:(id)sender
{
    self.btnRemember.selected = !self.btnRemember.selected;
}

- (IBAction)connectWithTwitter:(id)sender {
    __weak __typeof(self)weakSelf = self;
    [KLLicenseAgreement checkAcceptedUserAgreementInViewController:self completion:^(BOOL success) {
        if (success) {
            [weakSelf signInWithTwitter];
        }
    }];
}

- (void)signInWithTwitter {
    
    //[SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    __weak __typeof(self)weakSelf = self;
//    [SCTwitter shared].rootViewController = self;
//    [[KLApi instance] singUpAndLoginWithTwitter:^(BOOL success) {
//        
//        //[SVProgressHUD dismiss];
//        if (success) {
//            [weakSelf performSegueWithIdentifier:kTabBarSegueIdnetifier sender:nil];
//        } else {
//            [REAlertView showAlertWithMessage:NSLocalizedString(@"KL_STR_FACEBOOK_LOGIN_FALED_ALERT_TEXT", nil) actionSuccess:NO];
//        }
//    }];
    
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

- (void) presentWelcomeViewController{
    WelcomeViewController *viewController =
    [self.storyboard instantiateViewControllerWithIdentifier:@"WelcomeViewController"];
    
    UINavigationController *navViewController =
    [[UINavigationController alloc] initWithRootViewController:viewController];
    
    [self presentViewController:navViewController
                       animated:NO
                     completion:nil];
}


#pragma mark - notification event
- (void)loginSuccess
{
    NSLog(@"=========== XMPP LOGIN SUCCESS ==============");

}

@end

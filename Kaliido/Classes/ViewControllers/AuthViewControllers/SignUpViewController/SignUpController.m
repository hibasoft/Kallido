//
//  KLSignUpController.m
//  Kaliido
//
//  Created by Daron13/02/2014.
//  Copyright (c) 2014 Kaliido. All rights reserved.
//
#import "AppDelegate.h"
#import "SignUpController.h"
#import "WelcomeScreenViewController.h"
#import "KLLicenseAgreement.h"
#import "UIImage+Cropper.h"
#import "REAlertView+KLSuccess.h"

#import "KLApi.h"
#import "KLUser.h"
#import "KLImagePicker.h"
#import "REActionSheet.h"
//#import "InterestViewController.h"
#import "KLAuthWebService.h"
#import "KLWebService.h"
#import "KLUserRegistration.h"
#import "KLSettingsManager.h"
#import "WelcomeViewController.h"
#import "ECSlidingViewController.h"
@interface SignUpController ()
{
    UIView *viewAlert;
    UIView *viewAlertPane;
}
@property (weak, nonatomic) IBOutlet UITextField *fullNameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;


@property (strong, nonatomic) UIImage *cachedPicture;
@property (strong, nonatomic) NSString *fullName;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *password;


- (IBAction)chooseUserPicture:(id)sender;
- (IBAction)signUp:(id)sender;

@end

@implementation SignUpController

- (void)dealloc {
    NSLog(@"%@ - %@",  NSStringFromSelector(_cmd), self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userImage.layer.cornerRadius = self.userImage.frame.size.width / 2;
    self.userImage.layer.masksToBounds = YES;
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Actions

- (IBAction)hideKeyboard:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)chooseUserPicture:(id)sender {
    
    __weak __typeof(self)weakSelf = self;
    
    [KLImagePicker chooseSourceTypeInVC:self allowsEditing:YES result:^(UIImage *image) {
        
        [weakSelf.userImage setImage:image];
        weakSelf.cachedPicture = image;
    }];
}

- (IBAction)pressentUserAgreement:(id)sender {
    
    [KLLicenseAgreement checkAcceptedUserAgreementInViewController:self completion:nil];
}

- (IBAction)signUp:(id)sender {
    [self fireSignUp];
}

- (IBAction)actionRelationshipStatus:(id)sender
{
        [viewAlertPane removeFromSuperview];
        // show alert
        CGRect screenSize = [UIScreen mainScreen].bounds;
        CGFloat scale = screenSize.size.width/320;
        UIView *pane = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenSize.size.width, screenSize.size.height)];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320*scale, 380*scale)];
        int y = 0;
        for ( int i = 1; i <= 6; i++)
        {
            NSString *strName = [NSString stringWithFormat:@"relation%d", i];
            UIImage *img = [UIImage imageNamed:strName];
            CGSize s = img.size;
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setFrame:CGRectMake(160*scale- s.width/2, y, s.width, s.height)];
            y = y + s.height+1;
            [btn setBackgroundImage:img forState:UIControlStateNormal];
            [view addSubview:btn];
            [btn addTarget:self action:@selector(dismissPane) forControlEvents:UIControlEventTouchUpInside];
        }
        
        NSString *strName = [NSString stringWithFormat:@"relationcancel"];
        UIImage *img = [UIImage imageNamed:strName];
        CGSize s = img.size;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(160*scale- s.width/2, y+10, s.width, s.height)];
        [btn addTarget:self action:@selector(dismissPane) forControlEvents:UIControlEventTouchUpInside];
        y = y + s.height+10;
        [btn setBackgroundImage:img forState:UIControlStateNormal];
        [view addSubview:btn];
        
        view.center = CGPointMake(160*scale, screenSize.size.height + 250);
        [pane addSubview:view];
        pane.backgroundColor = [UIColor clearColor];
        [[[UIApplication sharedApplication] keyWindow] addSubview:pane];
        //[self.view addSubview:pane];
        viewAlertPane = pane;
        [UIView animateWithDuration:0.3 animations:^{
            pane.backgroundColor = [UIColor colorWithRed:70/255.0f green:57/255.0f blue:139/255.0f alpha:0.65f];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.4 animations:^{
                view.center = CGPointMake(160*scale, screenSize.size.height - 150);
            }];
        }];
        viewAlert = view;
}

- (IBAction) actionCancel:(id)sender
{
    [self dismissPane];
}

- (void) dismissPane
{
    CGRect screenSize = [UIScreen mainScreen].bounds;
    CGFloat scale = screenSize.size.width/320;
    
    [UIView animateWithDuration:0.4 animations:^{
        viewAlert.center = CGPointMake(160*scale, screenSize.size.height + 250);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            viewAlertPane.backgroundColor = [UIColor clearColor];
        }
                         completion:^(BOOL finished1) {
                             viewAlertPane.hidden = YES;
                         }
         ];
    }];
}

- (void)fireSignUp
{
    NSString *fullName = self.fullNameField.text;
    NSString *email = self.emailField.text;
    NSString *password = self.passwordField.text;
    
    if (fullName.length == 0 || password.length == 0 || email.length == 0) {
        [REAlertView showAlertWithMessage:NSLocalizedString(@"KL_STR_FILL_IN_ALL_THE_FIELDS", nil) actionSuccess:NO];
        return;
    }
    
    if (password.length < 8)
    {
        [REAlertView showAlertWithMessage:NSLocalizedString(@"KL_STR_PASSWORD_IS_TOO_SHORT", nil) actionSuccess:NO];
        return;
    }
    __weak __typeof(self)weakSelf = self;
    [KLLicenseAgreement checkAcceptedUserAgreementInViewController:self completion:^(BOOL userAgreementSuccess) {
        
        if (userAgreementSuccess) {
            KLUser.currentUser = [[KLUser alloc]init];
            KLUser *newUser = KLUser.currentUser;
            
            newUser.fullName = fullName;
            newUser.email = email;
            newUser.password = password;
            newUser.tags = [[NSMutableArray alloc] initWithObjects:@"ios", nil];
            
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
            
            void (^presentTabBar)(void) = ^(void) {
                
                [SVProgressHUD dismiss];
                [self presentWelcomeViewController];
//                [weakSelf performSegueWithIdentifier:kTabBarSegueIdnetifier sender:nil];
            };
            
            KLUserRegistration *user = [KLUserRegistration alloc];
            user.fullname = fullName;
            user.email = email;
            user.password = password;
            user.confirmPassword = password;
            user.quickBloxUserId = [NSString stringWithFormat:@"%d", 0];
            [[KLApi instance] startServices];
            
            [[KLAuthWebService getInstance] registerUser:user withCallback:^(BOOL success, KLAccessTokenResponse *response, NSError *error) {
                   if (success)
                   {
                       
                       
                       
                        [[KLApi instance] loginWithEmail:email password:password rememberMe:true completion:^(BOOL succ) {
                            if (!succ) {
                                [[KLApi instance] logout:^(BOOL logoutSuccess) {
                                    [SVProgressHUD dismiss];
                                }];
                            }else
                            {
                                if (weakSelf.cachedPicture) {
                                    
                                    [SVProgressHUD showProgress:0.f status:nil maskType:SVProgressHUDMaskTypeClear];
                                    [[KLWebService getInstance] fileUpload:UIImagePNGRepresentation(weakSelf.cachedPicture) storageName:@"Profilepic" progress:^(float progress) {
                                        [SVProgressHUD showProgress:progress status:nil maskType:SVProgressHUDMaskTypeClear];
                                    } withCallback:^(BOOL updateUserSuccess, NSDictionary *responseData, NSError *error2) {
                                        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
                                        if (responseData != nil)
                                        {
                                            [[KLWebService getInstance] updateUserPhotoUID:[responseData valueForKey:@"fileurl"] withCallback:^(BOOL success, NSDictionary *responsePhoto, NSError *error) {
                                                
                                                [[KLWebService getInstance] getProfile:[KLAuthWebService getInstance].accessToken withCallback:^(BOOL successProfile, NSDictionary *res, NSError *err) {
                                                    [KLUser.currentUser setUser:res];
                                                    
                                                    [SVProgressHUD dismiss];
                                                        presentTabBar();
                                                    
                                                    
                                                }];
                                                
                                            }];
                                        }else
                                        {
                                            [[KLWebService getInstance] getProfile:[KLAuthWebService getInstance].accessToken withCallback:^(BOOL successProfile, NSDictionary *res, NSError *err) {
                                                [KLUser.currentUser setUser:res];
                                                presentTabBar();
                                            }];
                                        }
                                    }];
                                }
                                else {
                                    
                                    [[KLWebService getInstance] getProfile:[KLAuthWebService getInstance].accessToken withCallback:^(BOOL successProfile, NSDictionary *res, NSError *err) {
                                        [KLUser.currentUser setUser:res];
                                        presentTabBar();
                                    }];

                                }
                            }
                        }];
                   }else
                   {
                       [[KLApi instance] logout:^(BOOL logoutSuccess) {
                           [SVProgressHUD dismiss];
                       }];
                   }
            }];
        }
    }];
    return;
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
@end

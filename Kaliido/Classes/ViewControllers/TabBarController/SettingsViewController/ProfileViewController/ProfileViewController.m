//
//  KLProfileViewController.m
//  Kaliido
//
//  Created by lysenko.mykhayl on 3/24/14.
//  Copyright (c) 2014 Kaliido. All rights reserved.
//

#import "ProfileViewController.h"
#import "KLPlaceholderTextView.h"
#import "KLApi.h"
#import "REAlertView+KLSuccess.h"
#import "KLImageView.h"

//#import "KLContentService.h"
#import "UIImage+Cropper.h"
#import "REActionSheet.h"
#import "KLImagePicker.h"
#import "KLUsersUtils.h"
#import "HeadInputViewController.h"
#import "InterestViewController.h"
#import "KLWebService.h"
#import "SubInterestViewController.h"
#import "AppDelegate.h"
#import "UIViewController+ECSlidingViewController.h"

@interface ProfileViewController () <UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet KLImageView *avatarView;
@property (weak, nonatomic) IBOutlet UITextField *fullNameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet KLPlaceholderTextView *statusField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *updateProfileButton;
@property (weak, nonatomic) IBOutlet UITextField *userDescription;
@property (strong, nonatomic) NSString *fullnameCache;
@property (strong, nonatomic) NSString *emailCache;
@property (strong, nonatomic) NSString *headLineCache;
@property (strong, nonatomic) NSString *aboutMeCache;
//@property (strong, nonatomic) NSArray *interestsCache;
@property (weak, nonatomic) IBOutlet UITextField *userAge;
@property (copy, nonatomic) NSString *descriptionCache;
@property (weak, nonatomic) IBOutlet UISwitch *showUserAge;
@property (weak, nonatomic) IBOutlet UITextField *facebookUrl;
@property (nonatomic, strong) UIImage *avatarImage;
@property (strong, nonatomic) UIDatePicker *birthDatePicker;
@property (weak, nonatomic) IBOutlet UITextField *headLineField;
@property (weak, nonatomic) IBOutlet UITextField *interestField;
@property (weak, nonatomic) IBOutlet UITextField *relationshipField;
@property (weak, nonatomic) IBOutlet UITextField *lookingforField;
@property (weak, nonatomic) IBOutlet UITextField *aboutmeField;


@end


@implementation ProfileViewController

#pragma mark - ProfileViewController Implementation

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.avatarView.imageViewType = KLImageViewTypeCircle;
    self.statusField.placeHolder = NSLocalizedString(@"KL_STR_ADDSTATUS", nil);
    [self initProfileView];
    [self setUpdateButtonActivity];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self updateProfileView];
    
    UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleLightContent;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    tapGesture.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tapGesture];
    [self setUpdateButtonActivity];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - ProfileView - Init

-(void)initProfileView {
    self.fullNameField.text = [KLUser.currentUser.getUserDic objectForKey:@"fullName"];
    self.emailField.text = KLUser.currentUser.email;
    self.statusField.text = KLUser.currentUser.status;
    self.showUserAge.on = KLUser.currentUser.isAgeShowen;
    self.profileDic = KLUser.currentUser.getUserDic;
    
    self.fullnameCache = KLUser.currentUser.fullName;
    self.emailCache = KLUser.currentUser.email;
    self.headLineCache = KLUser.currentUser.headline;
    self.aboutMeCache = KLUser.currentUser.aboutMe;
    //    self.interestsCache = [self.profileDic objectForKey:@"interests"];
    
    
    self.birthDatePicker = [[UIDatePicker alloc] init];
    self.birthDatePicker.datePickerMode = UIDatePickerModeDate;
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    [toolBar setBarTintColor:[UIColor colorWithRed:45.0f/255 green:0 blue:108.0f/255 alpha:1]];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(ShowBirthDate)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space, doneButton, nil]];
    self.userAge.inputAccessoryView = toolBar;
    self.userAge.inputView = self.birthDatePicker;
    
}

#pragma mark - ProfileView - Update

- (void)updateProfileView {
    
    
    //add learco : show headline & interest field
    NSString* tmpHeadLine = [self.profileDic objectForKey:@"headLine"];
    
    if(tmpHeadLine != nil && ![tmpHeadLine isEqual:[NSNull null]])
        self.headLineField.text = tmpHeadLine;
    
    NSString* tmpAboutMe = [self.profileDic objectForKey:@"aboutMe"];
    
    if(tmpAboutMe != nil && ![tmpAboutMe isEqual:[NSNull null]])
        self.aboutmeField.text = tmpAboutMe;
    
    
    NSDictionary* tmpRelationship = [self.profileDic objectForKey:@"relationship"];
    if(tmpRelationship != nil && ![tmpRelationship isEqual:[NSNull null]])
    {
        
        NSString* tmpRelationshipName = [tmpRelationship objectForKey:@"name"];
        
        if(tmpRelationshipName != nil && ![tmpRelationshipName isEqual:[NSNull null]])
            self.relationshipField.text = tmpRelationshipName;
    }
    
    
    
    //
    NSString* interestString = @"";
    
    NSArray * tmpArray = [self.profileDic objectForKey:@"interests"];
    if (tmpArray != nil && ![tmpArray isEqual:[NSNull null]]) {
        
        if (tmpArray.count == 1) {
            interestString = [[tmpArray objectAtIndex:0] objectForKey:@"name"];
        }else if (tmpArray.count > 1)
        {
            interestString = [[tmpArray objectAtIndex:0] objectForKey:@"name"];
            for (int i = 1; i < (int)tmpArray.count; i++) {
                interestString = [NSString stringWithFormat:@"%@, %@",interestString,  [[tmpArray objectAtIndex:i] objectForKey:@"name"]];
            }
            
        }
        
    }
    
    self.interestField.text = interestString;
    
    //
    NSString* lookingForsString = @"";
    
    tmpArray = [self.profileDic objectForKey:@"lookingFors"];
    if (tmpArray != nil && ![tmpArray isEqual:[NSNull null]]) {
        
        if (tmpArray.count == 1) {
            lookingForsString = [[tmpArray objectAtIndex:0] objectForKey:@"name"];
        }else if (tmpArray.count > 1)
        {
            lookingForsString = [[tmpArray objectAtIndex:0] objectForKey:@"name"];
            for (int i = 1; i < (int)tmpArray.count; i++) {
                lookingForsString = [NSString stringWithFormat:@"%@, %@",lookingForsString,  [[tmpArray objectAtIndex:i] objectForKey:@"name"]];
            }
            
        }
        
    }
    
    self.lookingforField.text = lookingForsString;
    
    
    
    //end
    UIImage *placeholder = [UIImage imageNamed:@"upic-placeholder"];
    
    NSURL *url = [NSURL URLWithString:KLUser.currentUser.photoUID];//[UsersUtils userAvatarURL:self.currentUser];
    
    [self.avatarView setImageWithURL:url
                         placeholder:placeholder
                             options:SDWebImageHighPriority
                            progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                NSLog(@"r - %d; e - %d", receivedSize, expectedSize);
                            } completedBlock:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                
                            }];
    
    if(KLUser.currentUser.birthDate != nil && ![KLUser.currentUser.birthDate isEqual:[NSNull null]] && KLUser.currentUser.birthDate.length > 0)
        self.userAge.text = [KLUser.currentUser.birthDate substringToIndex:10];
    
}

-(void) ShowBirthDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    self.userAge.text = [NSString stringWithFormat:@"%@", [formatter stringFromDate:self.birthDatePicker.date]];
    [self.userAge resignFirstResponder];
    [self setUpdateButtonActivity];
}

#pragma mark - Actions

- (IBAction)showAgeValueChanged:(id)sender {
    [self setUpdateButtonActivity];
}

- (IBAction)changeAvatar:(id)sender {
    
    __weak __typeof(self)weakSelf = self;
    [KLImagePicker chooseSourceTypeInVC:self allowsEditing:YES result:^(UIImage *image) {
        
        weakSelf.avatarImage = [image imageByCircularScaleAndCrop:weakSelf.avatarView.frame.size];
        weakSelf.avatarView.image = [image imageByCircularScaleAndCrop:weakSelf.avatarView.frame.size];
        [weakSelf setUpdateButtonActivity];
    }];
}

- (void)setUpdateButtonActivity {
    
    BOOL activity = [self fieldsWereChanged];
    self.updateProfileButton.enabled = activity;
}

- (IBAction)hideKeyboard:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)saveChanges:(id)sender {
    [self.view endEditing:YES];
    __weak __typeof(self)weakSelf = self;
    KLUser.currentUser.email = self.emailField.text;
    
    [SVProgressHUD showProgress:0.f status:nil maskType:SVProgressHUDMaskTypeClear];
    
    [[KLWebService getInstance] fileUpload:UIImagePNGRepresentation(self.avatarImage) storageName:@"Profilepic" progress:^(float progress) {
        [SVProgressHUD showProgress:progress status:nil maskType:SVProgressHUDMaskTypeClear];
    } withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        [SVProgressHUD dismiss];
        if (success)
        {
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
            
            [weakSelf.profileDic setValue:self.fullNameField.text forKey:@"fullName"];
            [weakSelf.profileDic setValue:self.showUserAge.on?@"true":@"false" forKey:@"isAgeShowen"];
            [weakSelf.profileDic setValue:self.userAge.text forKey:@"birthDate"];
            [weakSelf.profileDic setValue:[response valueForKey:@"fileurl"] forKey:@"photoUID"];
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setValue:[weakSelf.profileDic valueForKey:@"fullName"] forKey:@"fullname"];
            [dic setValue:[weakSelf.profileDic valueForKey:@"headLine"] forKey:@"headline"];
            [dic setValue:[weakSelf.profileDic valueForKey:@"aboutMe"] forKey:@"aboutme"];
            [dic setValue:[weakSelf.profileDic valueForKey:@"isAgeShowen"] forKey:@"isageshowen"];
            if (response != nil)
                [dic setValue:[response valueForKey:@"fileurl"] forKey:@"photoUID"];
            [[KLWebService getInstance] updateProfile:dic withCallback:^(BOOL succ, NSDictionary *res, NSError *err) {
                
                if (succ)
                {
                    KLUser.currentUser.fullName = self.fullNameField.text;
                    [[KLWebService getInstance] updateUserBirthDate:self.userAge.text isShown:self.showUserAge.on withCallback:^(BOOL succ2, NSDictionary *res2, NSError *err2) {
                        
                        [KLUser.currentUser setUser:self.profileDic];
                        
//                        [[KLApi instance] updateUser:nil image:nil progress:nil completion:^(BOOL updateKaliidoSuccess) {
                            [SVProgressHUD dismiss];
//
                            [weakSelf setUpdateButtonActivity];
//
                            [weakSelf.navigationController popViewControllerAnimated:YES];
                            AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                            UITabBarController *controller = (UITabBarController*) delegate.viewControllerTabbar;
                            self.slidingViewController.topViewController = controller;
                            [controller setSelectedIndex:0];
//                        }];
                        
                    }];
                }else
                {
                    [SVProgressHUD dismiss];
                }
            }];
        }
    }];
}

- (BOOL)fieldsWereChanged {
    
    if (self.avatarImage) return YES;
    if (![self.fullnameCache isEqualToString:KLUser.currentUser.fullName]) return YES;
    if (![self.emailCache isEqualToString:KLUser.currentUser.email]) return YES;
    if(KLUser.currentUser.birthDate != nil && ![KLUser.currentUser.birthDate isEqual:[NSNull null]] && KLUser.currentUser.birthDate.length > 0)
    {
        if (![self.userAge.text isEqualToString:[KLUser.currentUser.birthDate substringToIndex:10]]) return YES;
    }
    if (self.showUserAge.on != KLUser.currentUser.isAgeShowen) return YES;
    if (![self.headLineCache isEqualToString:[self.profileDic valueForKey:@"headLine"]]) return YES;
    if (![self.aboutMeCache isEqualToString:[self.profileDic valueForKey:@"aboutMe"]]) return YES;
    //    if (![self.statusTextCache isEqualToString:self.currentUser.status ?: @""]) return YES;
    
    return NO;
}

#pragma mark - UITextFieldDelegate & UITextViewDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField == self.fullNameField) {
        self.fullnameCache = str;
    }else if (textField == self.emailField)
    {
        self.emailCache = str;
    }
    [self setUpdateButtonActivity];
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    
    [self setUpdateButtonActivity];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - Navigations

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"AboutMeHeadInput"]) {
        HeadInputViewController *vc = [segue destinationViewController];
        vc.title = @"About Me";
        vc.parent = self;
    } else if ([[segue identifier] isEqualToString:@"HeadLineHeadInput"]) {
        HeadInputViewController *vc = [segue destinationViewController];
        vc.title = @"HeadLine";
        vc.parent = self;
    } else if ([[segue identifier] isEqualToString:@"RelationShipVC"]) {
        SubInterestViewController *vc = [segue destinationViewController];
        vc.title = @"RelationShip";
        vc.parent = self;
    }
    else if ([[segue identifier] isEqualToString:@"InterestViewController"]){
        InterestViewController *vc = [segue destinationViewController];
        vc.parent = self;
    }else if ([[segue identifier] isEqualToString:@"LookingForVC"]){
        SubInterestViewController *vc = [segue destinationViewController];
        vc.title = @"LookingFor";
        vc.parent = self;
    }else if ([[segue identifier] isEqualToString:@"RelationShipVC"]){
        SubInterestViewController *vc = [segue destinationViewController];
        vc.title = @"RelationShip";
        vc.parent = self;
    }
}

@end

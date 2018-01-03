//
//  DirectoryCreateViewController.m
//  Kaliido
//
//  Created by Learco on 8/2/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import "DirectoryCreateViewController.h"

#import "KLWebService.h"
#import "KLApi.h"
#import "KLImagePicker.h"
#import "DirectoryViewModel.h"
#import "REAlertView+KLSuccess.h"
#import "InterestViewController.h"
#import "KLBusiness.h"
#import "AppDelegate.h"
#import "KLUser.h"
#import "KLInterest.h"
@interface DirectoryCreateViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberField;
@property (weak, nonatomic) IBOutlet UITextField *mobileNumberField;
@property (weak, nonatomic) IBOutlet UITextField *address1Field;
@property (weak, nonatomic) IBOutlet UITextField *address2Field;
@property (weak, nonatomic) IBOutlet UITextField *suburbField;
@property (weak, nonatomic) IBOutlet UITextField *stateField;
@property (weak, nonatomic) IBOutlet UITextField *countryField;
@property (weak, nonatomic) IBOutlet UITextField *postcodeField;
@property (weak, nonatomic) IBOutlet UITextField *locationField;
@property (weak, nonatomic) IBOutlet UITextField *businessOpenTimeField;
@property (weak, nonatomic) IBOutlet UITextField *businessCloseTimeField;
@property (weak, nonatomic) IBOutlet UITextField *businessWorkingOpenMaskField;
@property (weak, nonatomic) IBOutlet UISwitch *isShowBusinessOpenTimeSwitch;
@property (weak, nonatomic) IBOutlet UITextField *webAddressField;
@property (weak, nonatomic) IBOutlet UITextField *mainContactNameField;
@property (weak, nonatomic) IBOutlet UITextField *interestsField;
@property (weak, nonatomic) IBOutlet UIImageView *bgPictureImageView;
@property (weak, nonatomic) IBOutlet UIImageView *profilePictureImageView;
@property (retain, nonatomic) UIImage * profileImage;
@property (retain, nonatomic) UIImage * backgroundImage;

@property (strong, nonatomic) UIDatePicker *businessOpenTimePicker;
@property (strong, nonatomic) UIDatePicker *businessCloseTimePicker;



@end

@implementation DirectoryCreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.interestArray = [NSMutableArray array];
    [self initView];

}
-(void)viewWillAppear:(BOOL)animated {
    NSString* interestString = @"";
    for (int i = 0; i < self.interestArray.count; i++) {
        interestString = [NSString stringWithFormat:@"%@, %@", interestString, [[self.interestArray objectAtIndex:i] objectForKey:@"name"]];
    }
    _interestsField.text = interestString;
    
}

-(void)initView
{
    self.emailField.text = KLUser.currentUser.email;
    self.mainContactNameField.text = KLUser.currentUser.fullName;
    
    self.businessOpenTimePicker = [[UIDatePicker alloc] init];
    self.businessOpenTimePicker.datePickerMode = UIDatePickerModeDateAndTime;
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    [toolBar setBarTintColor:[UIColor colorWithRed:45.0f/255 green:0 blue:108.0f/255 alpha:1]];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(onSelectBusinessOpenTimes)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space, doneButton, nil]];
    self.businessOpenTimeField.inputAccessoryView = toolBar;
    self.businessOpenTimeField.inputView = self.businessOpenTimePicker;
    
    //
    self.businessCloseTimePicker = [[UIDatePicker alloc] init];
    self.businessCloseTimePicker.datePickerMode = UIDatePickerModeDateAndTime;
    UIToolbar *toolBar1 = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    [toolBar1 setBarTintColor:[UIColor colorWithRed:45.0f/255 green:0 blue:108.0f/255 alpha:1]];
    UIBarButtonItem *doneButton1 = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(onSelectBusinessCloseTimes)];
    UIBarButtonItem *space1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar1 setItems:[NSArray arrayWithObjects:space1, doneButton1, nil]];
    self.businessCloseTimeField.inputAccessoryView = toolBar1;
    self.businessCloseTimeField.inputView = self.businessCloseTimePicker;
    //

    
}

-(void) onSelectBusinessOpenTimes
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    self.businessOpenTimeField.text = [NSString stringWithFormat:@"%@", [formatter stringFromDate:self.businessCloseTimePicker.date]];
    [self.businessOpenTimeField resignFirstResponder];
}

-(void) onSelectBusinessCloseTimes
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    self.businessCloseTimeField.text = [NSString stringWithFormat:@"%@", [formatter stringFromDate:self.businessCloseTimePicker.date]];
    [self.businessCloseTimeField resignFirstResponder];
}

- (IBAction)onTapTakeProfilePicture:(id)sender {
    __weak __typeof(self)weakSelf = self;
    [KLImagePicker chooseSourceTypeInVC:self allowsEditing:YES result:^(UIImage *image) {
        
        weakSelf.profileImage = [image resizedImageWithMaximumSize:CGSizeMake(150, 150)];
        [weakSelf.profilePictureImageView setImage:weakSelf.profileImage];
    }];
}
- (IBAction)onTapBackgroundPicture:(id)sender {
    __weak __typeof(self)weakSelf = self;
    [KLImagePicker chooseSourceTypeInVC:self allowsEditing:NO result:^(UIImage *image) {
        
        weakSelf.backgroundImage = [image resizedImageByWidth:640];
        [weakSelf.bgPictureImageView setImage:image];
    }];
}

-(IBAction)doneButtonClicked:(id)sender
{
    [self.view endEditing:YES];
    if ([self checkedAllField])
    {
        __weak __typeof(self)weakSelf = self;
        [[KLWebService getInstance] fileUpload:UIImagePNGRepresentation(self.profileImage) storageName:@"StumblerPic" progress:^(float progress) {
            [SVProgressHUD showProgress:progress status:nil maskType:SVProgressHUDMaskTypeClear];
        } withCallback:^(BOOL updateUserSuccess, NSDictionary *response, NSError *error) {
            if (updateUserSuccess)
            {
                
                if (self.backgroundImage != nil) {
                    [[KLWebService getInstance] fileUpload:UIImagePNGRepresentation(self.backgroundImage) storageName:@"StumblerPic" progress:^(float progress) {
                        [SVProgressHUD showProgress:progress status:nil maskType:SVProgressHUDMaskTypeClear];
                    } withCallback:^(BOOL updateUserSuccess, NSDictionary *response1, NSError *error) {
                        if (updateUserSuccess)
                        {
                            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
                            KLBusiness   *createModel = [[KLBusiness alloc] init];
                            createModel.emailAddress = weakSelf.emailField.text;
                            createModel.profilePictureBlogStorageUrl = [response valueForKey:@"fileurl"];
                            createModel.backgroundPictureBlobStorageUrl = [response1 valueForKey:@"fileurl"];
                            createModel.name = weakSelf.nameField.text;
                            createModel.phoneNumber = weakSelf.phoneNumberField.text;
                            createModel.mobileNumber = weakSelf.mobileNumberField.text;
                            createModel.addressLine1 = weakSelf.address1Field.text;
                            createModel.addressLine2 = weakSelf.address2Field.text;
                            createModel.suburb = weakSelf.suburbField.text;
                            createModel.state = weakSelf.stateField.text;
                            createModel.country = weakSelf.countryField.text;
                            createModel.postCode = weakSelf.postcodeField.text;
                            //                createModel.location = weakSelf.locationField.text;
                            createModel.businessOpenTime = weakSelf.businessOpenTimeField.text;
                            createModel.businessCloseTime = weakSelf.businessCloseTimeField.text;
                            createModel.showBusinessOpenTimes = weakSelf.isShowBusinessOpenTimeSwitch.on;
                            createModel.mainContactName = weakSelf.mainContactNameField.text;
                            createModel.businessWorkingOpenMask = weakSelf.businessWorkingOpenMaskField.text;
                            createModel.webAddress = weakSelf.webAddressField.text;
                            createModel.interests = [NSMutableArray array];
                            
                            for (int i = 0; i< self.interestArray.count; i++) {
                                
                                [createModel.interests addObject:[NSNumber numberWithInteger:[[[self.interestArray objectAtIndex:i] objectForKey:@"id"] integerValue]]];
                                
                            }
                            
                            
                            createModel.latitude = 0;
                            createModel.longitude = 0;
                            createModel.businessTypeId = _selectedCategoryId;
//                            createModel.businessTypeId = 4002;
                            [[KLWebService getInstance] createBusiness:createModel withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
                                [SVProgressHUD dismiss];
                                if (success)
                                    [self.navigationController popViewControllerAnimated:YES];
                                
                            }];
        
                        }else
                        {
                            [REAlertView showAlertWithMessage:@"Uploading photo failed." actionSuccess:NO];
                            [SVProgressHUD dismiss];
                        }
                    }];
                    
                }else{
                    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
                    KLBusiness   *createModel = [[KLBusiness alloc] init];
                    createModel.emailAddress = weakSelf.emailField.text;
                    createModel.profilePictureBlogStorageUrl = [response valueForKey:@"fileurl"];
                    createModel.name = weakSelf.nameField.text;
                    createModel.phoneNumber = weakSelf.phoneNumberField.text;
                    createModel.mobileNumber = weakSelf.mobileNumberField.text;
                    createModel.addressLine1 = weakSelf.address1Field.text;
                    createModel.addressLine2 = weakSelf.address2Field.text;
                    createModel.suburb = weakSelf.suburbField.text;
                    createModel.state = weakSelf.stateField.text;
                    createModel.country = weakSelf.countryField.text;
                    createModel.postCode = weakSelf.postcodeField.text;
                    //                createModel.location = weakSelf.locationField.text;
                    createModel.businessOpenTime = weakSelf.businessOpenTimeField.text;
                    createModel.businessCloseTime = weakSelf.businessCloseTimeField.text;
                    createModel.businessWorkingOpenMask = weakSelf.businessWorkingOpenMaskField.text;
                    createModel.showBusinessOpenTimes = weakSelf.isShowBusinessOpenTimeSwitch.on;
                    createModel.mainContactName = weakSelf.mainContactNameField.text;
                    createModel.webAddress = weakSelf.webAddressField.text;
                    createModel.backgroundPictureBlobStorageUrl = @"";
                    createModel.interests = [NSMutableArray array];
                    
                    
                    for (int i = 0; i< self.interestArray.count; i++) {
                        
                        [createModel.interests addObject:[NSNumber numberWithInteger:[[[self.interestArray objectAtIndex:i] objectForKey:@"id"] integerValue]]];
                         
                    }
                    
                    createModel.latitude = 0;
                    createModel.longitude = 0;
                    createModel.businessTypeId = _selectedCategoryId;
                    
                    [[KLWebService getInstance] createBusiness:createModel withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
                        [SVProgressHUD dismiss];
                        if (success)
                            [self.navigationController popViewControllerAnimated:YES];
                        
                    }];
                }
                
            }else
            {
                [REAlertView showAlertWithMessage:@"Uploading photo failed." actionSuccess:NO];
                [SVProgressHUD dismiss];
            }
        }];
    }else
    {
        [REAlertView showAlertWithMessage:@"Please Input All Fields." actionSuccess:NO];
    }
}


- (bool) checkedAllField{
    if (self.profileImage == nil)
        return NO;
    if (self.nameField.text.length == 0)
        return NO;
    if (self.phoneNumberField.text.length == 0)
        return NO;
    if (self.emailField.text.length == 0)
        return NO;
    
    return YES;
}

-(IBAction)onTapInterest:(id)sender
{
    InterestViewController * vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"InterestViewController"];
    vc.directoryParent = self;
    
    [self.navigationController pushViewController:vc animated:true];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

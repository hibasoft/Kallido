//
//  StumblerCreateViewController.m
//  Kaliido
//
//  Created by  Kaliido on 9/7/15.
//  Copyright (c) 2015 Kaliido. All rights reserved.
//

#import "StumblerCreateViewController.h"
#import "KLImagePicker.h"
#import "KLPlaceholderTextView.h"
#import "UIImage+Cropper.h"
#import "KLImageView.h"
#import "LocationTracker.h"
#import "MapViewController.h"
#import "SearchPeopleViewController.h"
#import "KLWebService.h"
#import "KLApi.h"

//#import "ContentService.h"
#import "REAlertView+KLSuccess.h"
#import "KLStumblerModel.h"
#import "StumblerCategoryViewController.h"

@interface StumblerCreateViewController () 
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView *avatarView;
@property (strong, nonatomic) IBOutlet UITextField *eventField;
@property (strong, nonatomic) IBOutlet UITextField *stumblerEventField;
@property (strong, nonatomic) IBOutlet UITextField *locationField;
@property (strong, nonatomic) IBOutlet KLPlaceholderTextView *detailTextView;
@property (strong, nonatomic) IBOutlet UITextField *dateField;
@property (strong, nonatomic) IBOutlet UITextField *peopleField;
@property (strong, nonatomic) IBOutlet UILabel *privacyLabel;

@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) UIImage *avatarImage;

@end

@implementation StumblerCreateViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.detailTextView setPlaceHolder:@"Details"];
    [self.detailTextView setBackgroundColor:[UIColor clearColor]];
    self.datePicker = [[UIDatePicker alloc] init];
    self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    [toolBar setBarTintColor:[UIColor colorWithRed:45.0f/255 green:0 blue:108.0f/255 alpha:1]];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(ShowBirthDate)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space, doneButton, nil]];
    self.dateField.inputAccessoryView = toolBar;
    self.dateField.inputView = self.datePicker;

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.scrollView addGestureRecognizer:tapGesture];
    
    self.peopleArray = [[NSMutableArray alloc] init];
    self.peopleNameArray = [[NSMutableArray alloc] init];
    self.peopleDataArray = [[NSMutableArray alloc] init];
    self.stumblerArray = [[NSMutableArray alloc] init];
    self.stumblerNameArray = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // register keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    if(self.currentPoint != nil)
    {
        self.locationField.text = self.currentPoint.title;
    }
    
    if (self.peopleNameArray.count)
    {
        self.peopleField.text = [self.peopleNameArray componentsJoinedByString:@","];
    }else
    {
        self.peopleField.text = @"";
    }
    
    if (self.stumblerArray.count)
    {
        self.stumblerEventField.text = [[self.stumblerArray valueForKey:@"name"] componentsJoinedByString:@","];
    }else
    {
        self.stumblerEventField.text = @"";
    }
    [self.navigationController setNavigationBarHidden:YES];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // unregister keyboard notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

-(void)hideKeyboard
{
    [self.view endEditing:YES];
}

-(void) ShowBirthDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd'T'HH:mm"];
    self.dateField.text = [NSString stringWithFormat:@"%@", [formatter stringFromDate:self.datePicker.date]];
    [self.dateField resignFirstResponder];
}

- (IBAction) actionBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (bool) checkedAllField{
    if (self.avatarImage == nil)
        return NO;
    if (self.eventField.text.length == 0)
        return NO;
    if (self.detailTextView.text.length == 0)
        return NO;
    if (self.currentPoint == nil)
        return NO;
    if (self.dateField.text.length == 0)
        return NO;
    if (self.peopleField.text.length == 0)
        return NO;
    return YES;
}
- (IBAction)doneButtonClicked:(id)sender {
    [self.view endEditing:YES];
    if ([self checkedAllField])
    {
        __weak __typeof(self)weakSelf = self;
        [[KLWebService getInstance] fileUpload:UIImagePNGRepresentation(self.avatarImage) storageName:@"StumblerPic" progress:^(float progress) {
            [SVProgressHUD showProgress:progress status:nil maskType:SVProgressHUDMaskTypeClear];
        } withCallback:^(BOOL updateUserSuccess, NSDictionary *response, NSError *error) {
            if (updateUserSuccess)
            {
                [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
                KLStumblerModel   *createModel = [[KLStumblerModel alloc] init];
                
                createModel.imageUID = [response valueForKey:@"fileurl"];
                createModel.name = weakSelf.eventField.text;
                createModel.post = weakSelf.detailTextView.text;
                createModel.latitude = [NSNumber numberWithDouble:self.currentPoint.coordinate.latitude];
                createModel.longitude = [NSNumber numberWithDouble:self.currentPoint.coordinate.longitude];
                createModel.date = weakSelf.dateField.text;
                createModel.privacy = weakSelf.privacyLabel.text;
                createModel.address = weakSelf.locationField.text;
                createModel.attendees = weakSelf.peopleArray;
                createModel.subcategoryids = [weakSelf.stumblerArray valueForKey:@"id"];
                [[KLWebService getInstance] createStumbler:createModel withCallback:^(BOOL success, NSDictionary *response2, NSError *error2) {
                    [SVProgressHUD dismiss];
                    if (success)
                        [self.navigationController popViewControllerAnimated:YES];
                }];
            }
        }];
    }else
    {
        [REAlertView showAlertWithMessage:@"Please Input All Fields." actionSuccess:NO];
    }
}

- (IBAction)imageButtonClicked:(id)sender {
    __weak __typeof(self)weakSelf = self;
    [KLImagePicker chooseSourceTypeInVC:self allowsEditing:YES result:^(UIImage *image) {
        
        weakSelf.avatarImage = image;
        [weakSelf.avatarView setImage:image];
    }];
}
- (IBAction)privacyButtonClicked:(id)sender {
    [self.privacyLabel setText:[self.privacyLabel.text isEqualToString:@"Privacy"]?@"Public":@"Privacy" ];
}

#pragma mark
#pragma mark Keyboard state
//the Function that call when keyboard show.
- (void)keyboardWasShown:(NSNotification *)notif {
    CGSize _keyboardSize = [[[notif userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0f, 0.0f, _keyboardSize.height, 0.0f);
    
//    CGRect missingLabelRect = [self.emailTextField.superview convertRect:self.emailTextField.frame toView:self.view];
//    if(self.view.frame.size.height - _keyboardSize.height < missingLabelRect.origin.y + missingLabelRect.size.height)
//    {
        self.scrollView.contentInset = contentInsets;
        self.scrollView.scrollIndicatorInsets = contentInsets;
//    }
}
//the Function that call when keyboard hide.
- (void)keyboardWillBeHidden:(NSNotification *)notif {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

- (IBAction)locationButtonClicked:(id)sender {
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"mapIdentifier"]){
        MapViewController *vc = [segue destinationViewController];
        vc.parent = self;
    }else if ([[segue identifier] isEqualToString:@"PeopleSearchSegue"])
    {
        SearchPeopleViewController *vc = [segue destinationViewController];
        vc.parent = self;
    }else if ([[segue identifier] isEqualToString:@"StumblerCategorySegue"]){
        StumblerCategoryViewController *vc = [segue destinationViewController];
        vc.parent = self;
    }
}
@end

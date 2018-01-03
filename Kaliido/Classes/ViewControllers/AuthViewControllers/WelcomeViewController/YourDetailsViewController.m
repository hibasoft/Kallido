//
//  YourDetailsViewController.m
//  Kaliido
//
//  Created by  Kaliido on 10/29/15.
//  Copyright © 2015 Kaliido. All rights reserved.
//

#import "YourDetailsViewController.h"
#import "HeadInputViewController.h"
//#import "SubInterestViewController.h"
//#import "InterestViewController.h"
#import "KLApi.h"
#import "KLWebService.h"


@interface YourDetailsViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userAge;
@property (weak, nonatomic) IBOutlet UISwitch *showUserAge;
@property (strong, nonatomic) UIDatePicker *birthDatePicker;
@end

@implementation YourDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.profileDic = KLUser.currentUser.getUserDic;
    self.birthDatePicker = [[UIDatePicker alloc] init];
    self.birthDatePicker.datePickerMode = UIDatePickerModeDate;
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    [toolBar setBarTintColor:[UIColor colorWithRed:45.0f/255 green:0 blue:108.0f/255 alpha:1]];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(ShowBirthDate)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space, doneButton, nil]];
    self.userAge.inputAccessoryView = toolBar;
    self.userAge.inputView = self.birthDatePicker;
    self.showUserAge.on = KLUser.currentUser.isAgeShowen;
}

-(void) ShowBirthDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    self.userAge.text = [NSString stringWithFormat:@"%@", [formatter stringFromDate:self.birthDatePicker.date]];
    [self.userAge resignFirstResponder];
}

- (IBAction)showAgeValueChanged:(id)sender {

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (IBAction)NextButtonClicked:(id)sender {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    __weak __typeof(self)weakSelf = self;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:[self.profileDic valueForKey:@"fullName"] forKey:@"fullname"];
    [dic setValue:[self.profileDic valueForKey:@"headLine"] forKey:@"headline"];
    [dic setValue:[self.profileDic valueForKey:@"aboutMe"] forKey:@"aboutme"];
    [[KLWebService getInstance] updateProfile:dic withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        
        if (success)
        {
            [[KLWebService getInstance] updateUserBirthDate:self.userAge.text isShown:self.showUserAge.on withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
                [SVProgressHUD dismiss];
                [weakSelf.profileDic setValue:self.showUserAge.on?@"true":@"false" forKey:@"isAgeShowen"];
                [weakSelf.profileDic setValue:self.userAge.text forKey:@"birthDate"];
                [KLUser.currentUser setUser:self.profileDic];
                [self performSegueWithIdentifier: @"InterestViewController" sender:self];
            }];
            
        }else
        {
            [SVProgressHUD dismiss];
        }
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"AboutMeHeadInput"]){
        HeadInputViewController *vc = [segue destinationViewController];
        vc.title = @"About Me";
        vc.detailParent = self;
    }else if ([[segue identifier] isEqualToString:@"HeadLineHeadInput"]){
        HeadInputViewController *vc = [segue destinationViewController];
        vc.title = @"HeadLine";
        vc.detailParent = self;
    }
    
}
@end

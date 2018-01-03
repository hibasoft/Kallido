//
//  VenueViewController.m
//  Kaliido
//
//  Created by Learco R on 5/24/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import "VenueViewController.h"
#import "HTAutoCompleteTextField.h"
#import "KLAutoCompleteManager.h"
#import "VenueViewMapTableViewCell.h"
#import "VenueViewItemTableViewCell.h"
#import "UIColor+CreateMethods.h"
#import "VenueDetailViewController.h"
#import "UIViewController+ECSlidingViewController.h"

@interface VenueViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *venueTable;
@property (strong, nonatomic) IBOutlet HTAutocompleteTextField *searchField;
@property (strong, nonatomic) UIButton  *searchButton;

@property (nonatomic, strong) NSArray *venueArray;
@end

@implementation VenueViewController

static NSString * const reuseIdentifierMap = @"MapCell";
static NSString * const reuseIdentifierItem = @"DetailCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.venueArray = @[@"UNICEF",@"Amnesty International",@"Community Brave",@"Kaleidoscope Australlia House Long String",@"Human Rights Campagin",@"GLLAD"];
    
    self.venueTable.dataSource = self;
    self.venueTable.delegate = self; 
    
    //init autocomplete searchField
    self.searchField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 1)];
    self.searchField.leftViewMode = UITextFieldViewModeAlways;
    self.searchField.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.searchField.layer.borderWidth = 1.0f;
    self.searchField.tintColor = [UIColor whiteColor];
    self.searchButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 33, 31)];
    self.searchButton.backgroundColor = [UIColor whiteColor];
    [self.searchButton setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [self.searchButton addTarget:self action:@selector(searchButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.searchField.rightView = self.searchButton;
    self.searchField.rightViewMode = UITextFieldViewModeAlways;
    
    [HTAutocompleteTextField setDefaultAutocompleteDataSource:[KLAutoCompleteManager sharedManager]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [super viewWillAppear:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (IBAction) actionNearBy:(id)sender
{
    [ self.slidingViewController anchorTopViewToRightAnimated:YES];
}
- (IBAction)ReturnButtonClicked:(id)sender {
    [self searchButtonClicked:nil];
}
- (void) searchButtonClicked:(UIButton*)sender

{
    [self.view endEditing:YES];
//    NSArray *interestIdArray = [self analysisInterestArray];
//    if(interestIdArray.count)
//    {
//        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
//        [[KLWebService getInstance] getUserSearchByInterests:interestIdArray withCallback:^(BOOL success, NSArray *response, NSError *error) {
//            self.userList = response;
//            [SVProgressHUD dismiss];
//            [self.collectionView reloadData];
//        }];
//    }else
//    {
//        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
//        [[KLWebService getInstance] getUsersByName:[self.searchField.text componentsSeparatedByString:@","].firstObject withCallback:^(BOOL success, NSArray *response, NSError *error) {
//            self.userList = response;
//            [SVProgressHUD dismiss];
//            [self.collectionView reloadData];
//        }];
//    }
}

//MARK: UITableView delegate

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0)
        return 208;
    else
        return 80;
    
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.venueArray.count+1;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
    
        VenueViewMapTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierMap];
        
        
        return cell;
    }else
    {
        VenueViewItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierItem];
        
        if (indexPath.row % 2 == 0)
        {
            [cell.contentView setBackgroundColor:[UIColor colorWithHex:@"#efeff4" alpha:1]];
        }else
        {
            [cell.contentView setBackgroundColor:[UIColor whiteColor]];
        }
        return cell;

    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row > 0)
    {
        VenueDetailViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"VenueDetailViewController"];
        [self.navigationController pushViewController:controller animated:YES];
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

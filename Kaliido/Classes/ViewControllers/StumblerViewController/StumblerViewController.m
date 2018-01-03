//
//  StumblerViewController.m
//  Kaliido
//
//  Created by  Kaliido on 1/28/15.
//  Copyright (c) 2015 Kaliido. All rights reserved.
//

#import "StumblerViewController.h"
#import "StumblerCell.h"
#import "StumblerDetailViewController.h"
#import "KLWebService.h"
#import "KLApi.h"


@interface StumblerViewController () < UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UITextField *searchField;
@property (strong, nonatomic) IBOutlet UITableView *mainTableView;
@property (strong, nonatomic) UIButton  *searchButton;
@property (strong, nonatomic) NSArray *stumblerArray;
@property (nonatomic) BOOL isKeyboardShow;
@end

@implementation StumblerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchField.tintColor = [UIColor whiteColor];
    self.searchField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 1)];
    self.searchField.leftViewMode = UITextFieldViewModeAlways;
    self.searchField.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.searchField.layer.borderWidth = 1.0f;
    
    self.searchButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 33, 31)];
    self.searchButton.backgroundColor = [UIColor whiteColor];
    [self.searchButton setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [self.searchButton addTarget:self action:@selector(searchButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.searchField.rightView = self.searchButton;
    self.searchField.rightViewMode = UITextFieldViewModeAlways;
    
    self.mainTableView.tableFooterView = [[UIView alloc] init];
    self.stumblerArray = [[NSArray alloc] init];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    if (self.categoryId)
    {
        [[KLWebService getInstance] getSearchByCategoryId:self.categoryId withCallback:^(BOOL success, NSArray *response, NSError *error) {
            self.stumblerArray = response;
            [SVProgressHUD dismiss];
        }];
    }else
    {
        [[KLWebService getInstance] getStumblerByName:self.searchString withCallback:^(BOOL success, NSArray *response, NSError *error) {
            [SVProgressHUD dismiss];
            self.stumblerArray = response;
            [self.mainTableView reloadData];
        }];
    }
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapRecognize:)];
    [tapGestureRecognizer setDelegate:self];
    [self.mainTableView addGestureRecognizer:tapGestureRecognizer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction) actionBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark
#pragma mark Keyboard state
//the Function that call when keyboard show.
- (void)keyboardWasShown:(NSNotification *)notif {
    self.isKeyboardShow = YES;
}
//the Function that call when keyboard hide.
- (void)keyboardWillBeHidden:(NSNotification *)notif {
    self.isKeyboardShow = NO;
}

#pragma mark - Tap gesture

- (void)didTapRecognize:(UITapGestureRecognizer*)sender {
    [self.view endEditing:YES];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (self.isKeyboardShow)
    {
        return YES;
    }
    return NO;
}

- (void) searchButtonClicked:(UIButton*)sender

{
    [self.view endEditing:YES];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [[KLWebService getInstance] getStumblerByName:self.searchField.text withCallback:^(BOOL success, NSArray *response, NSError *error) {
        [SVProgressHUD dismiss];
        self.stumblerArray = response;
        [self.mainTableView reloadData];
    }];
}
- (IBAction)ReturnButtonClicked:(id)sender {
    [self searchButtonClicked:nil];
}

#pragma mark - TableView Delegate

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.stumblerArray.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StumblerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"stumblercell"];
    cell.btnCheckMark.enabled = indexPath.row %2;
    [cell updateData:[self.stumblerArray objectAtIndex:indexPath.row]];
    return cell;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dataDic = [self.stumblerArray objectAtIndex:indexPath.row];
    int stumblerId = (int)[[dataDic valueForKey:@"id"] integerValue];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [[KLWebService getInstance] getStumblerById:stumblerId withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        [SVProgressHUD dismiss];
        if (success)
        {
            KLStumblerModel *model = [KLStumblerModel objectWithDictionary:response];
            StumblerDetailViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"StumblerDetailViewController"];
            controller.model = model;
            [self.navigationController pushViewController:controller animated:YES];
        }
    }];
}
@end

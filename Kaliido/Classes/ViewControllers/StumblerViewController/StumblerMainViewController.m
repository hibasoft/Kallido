//
//  StumblerMainViewController.m
//  Kaliido
//
//  Created by  Kaliido on 9/8/15.
//  Copyright (c) 2015 Kaliido. All rights reserved.
//

#import "StumblerMainViewController.h"
#import "UIViewController+ECSlidingViewController.h"
#import "KLWebService.h"
#import "StumblerCell.h"
#import "StumblerCollectionViewCell.h"

#import "StumblerDetailViewController.h"
#import "StumblerViewController.h"
#import "InterestCollectionViewCell.h"

@interface StumblerMainViewController () <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet UIButton *mainTableViewBackButton;
@property (strong, nonatomic) IBOutlet UITableView *menuTableView;
@property (strong, nonatomic) IBOutlet UITableView *mainTableView;
@property (strong, nonatomic) IBOutlet UIView *mainTableFooterView;
@property (strong, nonatomic) IBOutlet UIImageView *upArrowImageView;
@property (strong, nonatomic) IBOutlet UILabel *upcomingLabel;
@property (strong, nonatomic) IBOutlet UICollectionView *categoryCollectionView;
@property (strong, nonatomic) IBOutlet UITextField *searchField;
@property (strong, nonatomic) UIButton  *searchButton;


@property (nonatomic, strong) NSArray *menuItems;
@property (nonatomic, strong) NSArray *iconItems;
@property (nonatomic) NSInteger     selectIndex;

@property (nonatomic, strong) NSMutableArray *upcomingArray;
@property (nonatomic, strong) NSMutableArray *categoryArray;
@end
@implementation StumblerMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _menuItems = @[@"Upcoming" , @"Invites", @"Hosting", @"Past", @"City"];
    _iconItems = @[@"upcoming",@"invites",@"hosting",@"past",@"city"];
    self.selectIndex = 0;
    self.upcomingLabel.text = _menuItems[self.selectIndex];
    
    self.upcomingArray = [[NSMutableArray alloc] init];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [[KLWebService getInstance] getStumblerCategoryAll:^(BOOL success, NSArray *response, NSError *error) {
        [SVProgressHUD dismiss];
        self.categoryArray = (NSMutableArray*)response;
        [self.categoryCollectionView reloadData];
    }];
    
    [[KLWebService getInstance] getFutureByStatus:0 withCallback:^(BOOL success, NSArray *response, NSError *error) {
        [SVProgressHUD dismiss];
        self.upcomingArray = [NSMutableArray arrayWithArray:response];
        [self.categoryCollectionView reloadData];
    }];
    
    
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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (IBAction) actionMenu:(id)sender
{
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.menuTableView)
        return 4;
    else
        return self.upcomingArray.count;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.menuTableView)
        return 50.0f;
    else
        return 200.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.menuTableView)
    {
        static NSString* menuTableIdentifier = @"MenuIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:menuTableIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:menuTableIdentifier];
    
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
        
        cell.imageView.image = [UIImage imageNamed:_iconItems[indexPath.row]];
        cell.textLabel.text = _menuItems[indexPath.row];
        if(indexPath.row == self.selectIndex)
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        else
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        return cell;
    }else
    {
        StumblerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"stumblercell"];
        [cell updateData:self.upcomingArray[indexPath.row]];
        cell.btnCheckMark.enabled = indexPath.row %2;
        return cell;
    }
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (tableView == self.menuTableView)
    {
        self.selectIndex = indexPath.row;
        self.upcomingLabel.text = _menuItems[self.selectIndex];
        [self menuButtonClicked:nil];
        [tableView reloadData];
        
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        if (indexPath.row < 2)
        {
            [[KLWebService getInstance] getFutureByStatus:(int)indexPath.row withCallback:^(BOOL success, NSArray *response, NSError *error) {
                [SVProgressHUD dismiss];
                self.upcomingArray = [NSMutableArray arrayWithArray:response];
                [self.categoryCollectionView reloadData];
            }];
        }else if (indexPath.row == 2)
        {
            [[KLWebService getInstance] getStumblerAllPastHosted:^(BOOL success, NSArray *response, NSError *error) {
                [SVProgressHUD dismiss];
                self.upcomingArray = [NSMutableArray arrayWithArray:response];
                [self.categoryCollectionView reloadData];
            }];
        }
        else if (indexPath.row == 3)
        {
            [[KLWebService getInstance] getStumblerAllPast:^(BOOL success, NSArray *response, NSError *error) {
                [SVProgressHUD dismiss];
                self.upcomingArray = [NSMutableArray arrayWithArray:response];
                [self.categoryCollectionView reloadData];
            }];
        }else
        {
            [SVProgressHUD dismiss];
        }
    }else{
        NSDictionary *dataDic = [self.upcomingArray objectAtIndex:indexPath.row];
        int stumblerId = [[dataDic valueForKey:@"id"] integerValue];
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
}

- (IBAction)menuButtonClicked:(id)sender {
    if (self.menuTableView.hidden)
    {
        self.menuTableView.hidden = NO;
        self.upArrowImageView.hidden = NO;
        self.mainTableViewBackButton.hidden = NO;
    }else
    {
        self.menuTableView.hidden = YES;
        self.upArrowImageView.hidden = YES;
        self.mainTableViewBackButton.hidden = YES;
    }
}

- (IBAction)menuViewBackButtonClicked:(id)sender {
    self.menuTableView.hidden = YES;
    self.upArrowImageView.hidden = YES;
    self.mainTableViewBackButton.hidden = YES;
}

- (IBAction)categoryButtonClicked:(UIButton *)sender {
    StumblerViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"StumblerViewController"];
    controller.categoryId = (int)sender.tag;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - UICollectionView
-  (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return (self.upcomingArray.count>0)? 2:1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0 && self.upcomingArray.count)
        return self.upcomingArray.count;
    return [self.categoryArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && self.upcomingArray.count)
    {
        StumblerCollectionViewCell *cell = (StumblerCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"stumblercell" forIndexPath:indexPath];
        [cell updateData:self.upcomingArray[indexPath.row]];
        cell.btnCheckMark.enabled = indexPath.row %2;
        return cell;
    }else
    {
        InterestCollectionViewCell *cell = (InterestCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"InterestCell" forIndexPath:indexPath];
        cell.lblInterestName.text = [[self.categoryArray objectAtIndex:indexPath.row] valueForKey:@"name"];
        
        NSString* imageName = [NSString stringWithFormat:@"stumbler%d", indexPath.row +1];
        NSString* imageName_sel = [NSString stringWithFormat:@"stumbler%dsel", indexPath.row+1 ];
        UIImageView* normalImage = [[UIImageView alloc] initWithFrame:cell.frame];
        UIImageView* selectedImage = [[UIImageView alloc] initWithFrame:cell.frame];
        [normalImage setImage:[UIImage imageNamed:imageName]];
        [selectedImage setImage:[UIImage imageNamed:imageName_sel]];
        
        NSString* imageName_icon = [NSString stringWithFormat:@"stumbler%dicon", indexPath.row+1 ];
        [cell.imgInterest setImage:[UIImage imageNamed:imageName_icon]];
        
        
        cell.selectedBackgroundView = selectedImage;
        cell.backgroundView = normalImage;
        cell.lblInterestName.highlightedTextColor = [UIColor whiteColor];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:70.0/255.0f green:57.0/255.0f blue:139/255.0f alpha:1.0f];
        
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && self.upcomingArray.count)
    {
        NSDictionary *dataDic = [self.upcomingArray objectAtIndex:indexPath.row];
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
    }else
    {
        StumblerViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"StumblerViewController"];
        controller.categoryId = (int)[[[self.categoryArray objectAtIndex:indexPath.row] valueForKey:@"id"] integerValue];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && self.upcomingArray.count)
        return CGSizeMake(self.categoryCollectionView.frame.size.width, 200);
    return CGSizeMake(self.categoryCollectionView.frame.size.width/2-1, self.categoryCollectionView.frame.size.width/2-1);
}

- (void) searchButtonClicked:(UIButton*)sender

{
    [self.view endEditing:YES];
    StumblerViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"StumblerViewController"];
    controller.searchString = self.searchField.text;
    [self.navigationController pushViewController:controller animated:YES];
}
- (IBAction)ReturnButtonClicked:(id)sender {
    [self searchButtonClicked:nil];
}
@end

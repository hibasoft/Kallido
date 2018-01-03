//
//  NearbyUsersViewController.m
//  Kaliido
//
//  Created by Robbie Tapping on 31/08/2015.
//  Copyright (c) 2015 Kaliido. All rights reserved.
//

#import "NearbyUsersViewController.h"
#import "FriendsDetailsController.h"
#import "MainTabBarController.h"
#import "NearbyUserCollectionViewCell.h"
#import "FriendsListDataSource.h"
#import "KLApi.h"
#import "UIViewController+ECSlidingViewController.h"
#import "FriendsDetailsController.h"
#import "FriendsDetailsContainerController.h"
#import "KLWebService.h"

#import "KLAutoCompleteManager.h"
#import "HTAutoCompleteTextField.h"

@interface NearbyUsersViewController ()
<UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate, FriendsListDataSourceDelegate,UsersListDelegate, FriendsTabDelegate,UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet HTAutocompleteTextField *searchField;
@property (weak, nonatomic) IBOutlet UIButton *searchButtonView;
@property (strong, nonatomic) UIButton  *searchButton;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UIButton *FavouriteButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) FriendsListDataSource *dataSource;
@property (nonatomic, strong) NSArray *userList;
@property (nonatomic, strong) NSArray *interestArray;
@property (nonatomic) BOOL isKeyboardShow;
@property (weak, nonatomic) IBOutlet UIView *searchBoxView;

@property (retain, nonatomic) UIRefreshControl *refreshControl ;

@end

@implementation NearbyUsersViewController

static NSString * const reuseIdentifier = @"Cell";


- (void)viewDidLoad {
    [super viewDidLoad];

    ((MainTabBarController *)self.tabBarController).tabDelegate = self;
    
    __weak __typeof(self)weakSelf = self;
    void (^reloadDatasource)(void) = ^(void) {
        [weakSelf.collectionView reloadData];
    };
//    [[ChatReceiver instance] usersHistoryUpdatedWithTarget:self block:reloadDatasource];
//    [[ChatReceiver instance] chatContactListUpdatedWithTarget:self block:reloadDatasource];
    [self friendsListTabWasTapped:nil];
//    [self.searchBar setReturnKeyType:UIReturnKeyDone];
    [self.searchBoxView setHidden:YES];
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
    [self getInterestArray];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapRecognize:)];
    [tapGestureRecognizer setDelegate:self];
    [self.collectionView addGestureRecognizer:tapGestureRecognizer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor grayColor];
    [self.refreshControl addTarget:self action:@selector(refershControlAction) forControlEvents:UIControlEventValueChanged];
    [self.searchBoxView setHidden:YES];
    [self.collectionView addSubview:self.refreshControl];
    self.collectionView.alwaysBounceVertical = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:)    name:UIDeviceOrientationDidChangeNotification  object:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)orientationChanged:(NSNotification *)notification{
    [self adjustViewsForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
}

- (void) adjustViewsForOrientation:(UIInterfaceOrientation) orientation {
    
    [self.collectionView reloadData];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)refershControlAction
{
    if (self.FavouriteButton.selected)
    {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        
        [[KLWebService getInstance] getAllFavourites:^(BOOL success, NSArray *response, NSError *error) {
            self.userList = response;
            [SVProgressHUD dismiss];
            [self.collectionView reloadData];
            [self.refreshControl endRefreshing];
        }];
    }else
    {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        
        [[KLWebService getInstance] getUsersByName:self.searchField.text withCallback:^(BOOL success, NSArray *response, NSError *error) {
            self.userList = response;
            [SVProgressHUD dismiss];
            [self.collectionView reloadData];
            [self.refreshControl endRefreshing];
        }];
    }
    
}
- (IBAction) actionNearBy:(id)sender
{
    [ self.slidingViewController anchorTopViewToRightAnimated:YES];
}


- (IBAction)searchButtonPressed:(id)sender {
    
    
    
    if(self.searchBoxIsVisible)
    {
        self.searchBoxView.hidden = YES;
        self.searchBoxIsVisible = NO;
    }else{
         self.searchBoxView.hidden = NO;
        self.searchBoxIsVisible = YES;
    }
    
    
}

- (void) getInterestArray
{
    [[KLWebService getInstance] getInterests:^(BOOL success, NSArray *response, NSError *error) {
        self.interestArray = response;
        [[KLAutoCompleteManager sharedManager] setAutoCompleteArray:[self.interestArray valueForKeyPath:@"name"]];
    }];
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

#pragma mark - CollectionViewDelegate


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.userList.count;
}
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NearbyUserCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFriendsListCellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    
        
    
    NSDictionary *userDic = self.userList[indexPath.row];
    [cell updateData:userDic];
    
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (IS_IPAD)
    {
        return CGSizeMake(SCREEN_WIDTH/4, SCREEN_WIDTH/4);
    }else
    {
        if (SCREEN_WIDTH > SCREEN_HEIGHT) {
            //landscape
            return CGSizeMake(SCREEN_WIDTH/4, SCREEN_WIDTH/4);
        }else
        {
            return CGSizeMake(SCREEN_WIDTH/3, SCREEN_WIDTH/3);
        }
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [[KLWebService getInstance] getUserById:(int)[[self.userList[indexPath.row] valueForKey:@"id"] integerValue] withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        [SVProgressHUD dismiss];
        if (success)
        {
            
            
            FriendsDetailsContainerController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"FriendsDetailsContainerController"];
            controller.userDic = response;
            [self.navigationController pushViewController:controller animated:YES];
        }
    }];
    
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    __block NSString *tsearch = [searchText copy];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if ([searchBar.text isEqualToString:tsearch]) {
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
            [[KLWebService getInstance] getUsersByName:tsearch withCallback:^(BOOL success, NSArray *response, NSError *error) {
                self.userList = response;
                [SVProgressHUD dismiss];
                [self.collectionView reloadData];
            }];
        }
    });
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}
#pragma mark - UsersListCellDelegate

- (void)usersListCell:(NearbyUserCollectionViewCell *)cell pressAddBtn:(UIButton *)sender {
    
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    NSDictionary *datasource = [self.userList objectAtIndex:indexPath.row];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    if (!sender.selected)
    {
        [[KLWebService getInstance] addFavorite:[[datasource valueForKey:@"id"] integerValue] withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
            sender.selected = !sender.selected;
            [SVProgressHUD dismiss];
        }];
    }else
    {
        [[KLWebService getInstance] removeFavorite:[[datasource valueForKey:@"id"] integerValue] withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
            sender.selected = !sender.selected;
            [SVProgressHUD dismiss];
        }];
    }
}

#pragma mark - prepareForSegue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
}

#pragma mark - FriendsListDataSourceDelegate

- (void)didChangeContactRequestsCount:(NSUInteger)contactRequestsCount
{
    NSUInteger idx = [self.tabBarController.viewControllers indexOfObject:self.navigationController];
    if (idx != NSNotFound) {
        UITabBarItem *item = self.tabBarController.tabBar.items[idx];
        item.badgeValue = contactRequestsCount > 0 ? [NSString stringWithFormat:@"%d", contactRequestsCount] : nil;
    }
}


#pragma mark - FriendsTabDelegaterequestRoomOnlineUsers

- (void)friendsListTabWasTapped:(UITabBarItem *)tab
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [[KLWebService getInstance] getUsersClosestByDistance:200 withCallback:^(BOOL success, NSArray *response, NSError *error) {
        [SVProgressHUD dismiss];
        if(success)
        {
           
            self.userList = response;
            [self.collectionView reloadData];
            
            
        }else{
            [self.collectionView reloadData];
        }
    }];
}

- (IBAction)FavouriteButtonClicked:(id)sender {
    self.FavouriteButton.selected = !self.FavouriteButton.selected;
    if (self.FavouriteButton.selected)
    {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        
        [[KLWebService getInstance] getAllFavourites:^(BOOL success, NSArray *response, NSError *error) {
            self.userList = response;
            [SVProgressHUD dismiss];
            [self.collectionView reloadData];
            
        }];
    }else
    {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];

        [[KLWebService getInstance] getUsersByName:self.searchField.text withCallback:^(BOOL success, NSArray *response, NSError *error) {
            self.userList = response;
            [SVProgressHUD dismiss];
            [self.collectionView reloadData];
            
        }];
    }
}

- (void) searchButtonClicked:(UIButton*)sender

{
    [self.view endEditing:YES];
    NSArray *interestIdArray = [self analysisInterestArray];
    if(interestIdArray.count)
    {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        [[KLWebService getInstance] getUserSearchByInterests:interestIdArray withCallback:^(BOOL success, NSArray *response, NSError *error) {
            self.userList = response;
            [SVProgressHUD dismiss];
            [self.collectionView reloadData];
        }];
    }else
    {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        [[KLWebService getInstance] getUsersByName:[self.searchField.text componentsSeparatedByString:@","].firstObject withCallback:^(BOOL success, NSArray *response, NSError *error) {
            self.userList = response;
            [SVProgressHUD dismiss];
            [self.collectionView reloadData];
        }];
    }
}

- (IBAction)ReturnButtonClicked:(id)sender {
    [self searchButtonClicked:nil];
}

- (NSArray*) analysisInterestArray
{
    NSArray *interestValueArray = [[self.interestArray valueForKeyPath:@"name"] valueForKey:@"lowercaseString"];
    NSArray *interestIdArray = [self.interestArray valueForKeyPath:@"id"];
    
    NSArray *componentsString = [[self.searchField.text componentsSeparatedByString:@","] valueForKey:@"lowercaseString"];
    
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    for (NSString* interest in componentsString)
    {
        NSString *compareString = [interest stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSUInteger index = [interestValueArray indexOfObject:compareString];
        if (index != NSNotFound)
            [returnArray addObject:[interestIdArray objectAtIndex:index]];
    }
    return returnArray;
}
@end

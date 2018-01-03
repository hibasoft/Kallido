 //
//  FriendListController.m
//  Kaliido
//
//  Created by Daron on 7/07/2014.
//  Copyright (c) 2014 Kaliido. All rights reserved.
//

#import "FriendListViewController.h"
#import "FriendsDetailsController.h"
#import "MainTabBarController.h"
#import "FriendListCell.h"
#import "FriendsListDataSource.h"
#import "KLApi.h"
#import "UIViewController+ECSlidingViewController.h"
#import "FriendsDetailsController.h"
#import "FriendsDetailsContainerController.h"
#import "KLWebService.h"


@interface FriendListViewController ()

<UICollectionViewDataSource, UICollectionViewDelegate, UISearchDisplayDelegate, FriendsListDataSourceDelegate, FriendsTabDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collecitonView;
@property (nonatomic, strong) FriendsListDataSource *dataSource;

@end



@implementation FriendListViewController

- (void)dealloc {
    NSLog(@"%@ - %@",  NSStringFromSelector(_cmd), self);
}

#define kSHOW_SEARCH 0

- (void)viewDidLoad {
    [super viewDidLoad];
    ((MainTabBarController *)self.tabBarController).tabDelegate = self;
    
#if kSHOW_SEARCH
    [self.tableView setContentOffset:CGPointMake(0, self.searchDisplayController.searchBar.frame.size.height) animated:NO];
#endif
    self.dataSource = [[FriendsListDataSource alloc] initWithCollectionView:self.collecitonView searchDisplayController:self.searchDisplayController];
    self.dataSource.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.dataSource.viewIsShowed = YES;
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.dataSource.viewIsShowed = NO;
    [super viewWillDisappear:animated];
}

- (IBAction) actionNearBy:(id)sender
{
    
    [ self.slidingViewController anchorTopViewToRightAnimated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - CollectionViewDelegate


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
     return [self.dataSource numberOfSectionsInCollectionView:collectionView];
}
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.dataSource collectionView:collectionView cellForItemAtIndexPath:indexPath];
}
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize cellSize = CGSizeMake(160, 177);
    CGRect rc = [UIScreen mainScreen].bounds;
    CGFloat scale = rc.size.width/(2*cellSize.width);
    return CGSizeMake(cellSize.width * scale, cellSize.height *scale);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    if (cell.reuseIdentifier == kDontHaveAnyFriendsCellIdentifier) {
        return;
    }
    
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 59;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.reuseIdentifier == kDontHaveAnyFriendsCellIdentifier) {
        return;
    }
    
    KLUser *selectedUser = [self.dataSource userAtIndexPath:indexPath];
//    ContactListItem *item = [[KLApi instance] contactItemWithUserID:selectedUser.ID];
//
//    if (item) {
//       // [self performSegueWithIdentifier:kDetailsSegueIdentifier sender:nil];
//    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.dataSource tableView:tableView titleForHeaderInSection:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataSource numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.dataSource tableView:tableView cellForRowAtIndexPath:indexPath];
}


#pragma mark - UISearchDisplayDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    return [self.dataSource searchDisplayController:controller shouldReloadTableForSearchString:searchString];
}

-(void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    [self.dataSource searchDisplayControllerWillBeginSearch:controller];
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    [self.dataSource searchDisplayControllerWillEndSearch:controller];
}


#pragma mark - prepareForSegue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:kDetailsSegueIdentifier]) {
        
        NSIndexPath *indexPath = nil;
        if (self.searchDisplayController.isActive) {
            indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
        } else {
            indexPath = [[self.collecitonView indexPathsForSelectedItems] objectAtIndex:0];
        }
        FriendsDetailsController *vc = segue.destinationViewController;
        vc.selectedUser = [self.dataSource userAtIndexPath:indexPath];
    }
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
    
    [[KLWebService getInstance] getUsersClosestByDistance:50 withCallback:^(BOOL success, NSArray *response, NSError *error) {
        if(success)
        {
            [self.collecitonView reloadData];
        }else{
            [self.collecitonView reloadData];        }
    }];
    [self.collecitonView reloadData];
}


@end

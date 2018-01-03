
//
//  FriendsListDataSource.m
//  Kaliido
//
//  Created by Daron on 4/3/14.
//

#import "FriendsListDataSource.h"
#import "FriendListViewController.h"
//#import "UsersService.h"
#import "FriendListCell.h"
#import "KLApi.h"
//#import "UsersService.h"

//#import "ChatReceiver.h"
#import "REAlertView.h"
#import "KLWebService.h"


@interface FriendsListDataSource()


@property (strong, nonatomic) NSArray *searchResult;
@property (strong, nonatomic) NSArray *friendList;

@property (weak, nonatomic) UICollectionView *collectionView;
@property (weak, nonatomic) UISearchDisplayController *searchDisplayController;
//@property (strong, nonatomic) NSObject<Cancelable> *searchOperation;

@property (strong, nonatomic) id tUser;
@property (assign, nonatomic) NSUInteger contactRequestsCount;

@end

@implementation FriendsListDataSource

@synthesize friendList = _friendList;

- (void)dealloc {
    NSLog(@"%@ - %@",  NSStringFromSelector(_cmd), self);
    
}

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView searchDisplayController:(UISearchDisplayController *)searchDisplayController
{
    
    self = [super init];
    if (self) {
        
        self.collectionView = collectionView;
        self.collectionView.dataSource = self;
        self.searchResult = [NSArray array];
        
        self.searchDisplayController = searchDisplayController;
        __weak __typeof(self)weakSelf = self;
        
        void (^reloadDatasource)(void) = ^(void) {
            
//            if (weakSelf.searchOperation) {
//                return;
//            }
            
            if (self.searchDisplayController.isActive) {
                
                CGPoint point = weakSelf.searchDisplayController.searchResultsTableView.contentOffset;
                
//                weakSelf.friendList = [KLApi instance].friends;
                [weakSelf.searchDisplayController.searchResultsTableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)]   withRowAnimation:UITableViewRowAnimationAutomatic];
//                [weakSelf.tableView reloadData];
                NSUInteger idx = [weakSelf.friendList indexOfObject:weakSelf.tUser];
                NSUInteger idx2 = [weakSelf.searchResult indexOfObject:weakSelf.tUser];
               
                if (idx != NSNotFound && idx2 != NSNotFound) {
                    
                    point .y += 59;
                    weakSelf.searchDisplayController.searchResultsTableView.contentOffset = point;
                    
                    weakSelf.tUser = nil;
                    [SVProgressHUD dismiss];
                }
            }
            else {
                [weakSelf reloadDataSource];
            }
        };
        
        
        UINib *friendsCellNib = [UINib nibWithNibName:@"FriendListCell" bundle:nil];
        UINib *noResultsCellNib = [UINib nibWithNibName:@"NoResultsCell" bundle:nil];
        
        [searchDisplayController.searchResultsTableView registerNib:friendsCellNib forCellReuseIdentifier:kFriendsListCellIdentifier];
        [searchDisplayController.searchResultsTableView registerNib:noResultsCellNib forCellReuseIdentifier:kDontHaveAnyFriendsCellIdentifier];
    }
    
    return self;
}

- (void)setFriendList:(NSArray *)friendList {
//    _friendList = [KLUsersUtils sortUsersByFullname:friendList];
}

- (NSArray *)friendList {
    
    if (self.searchDisplayController.isActive && self.searchDisplayController.searchBar.text.length > 0) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.fullName CONTAINS[cd] %@", self.searchDisplayController.searchBar.text];
        NSArray *filtered = [_friendList filteredArrayUsingPredicate:predicate];
        
        return filtered;
    }
//    self.friendList = [KLApi instance].friends;
    return _friendList;
}

- (void)reloadDataSource {
    
//    self.friendList = [KLApi instance].friends;
    
    [[KLWebService getInstance] getUsersClosestByDistance:50 withCallback:^(BOOL success, NSArray *response, NSError *error) {
        if(success)
        {
            //self.friendList = response;
            

        }else{
//            self.friendList = [KLApi instance].friends;

        }
    }];
    
    if (self.viewIsShowed) {
        [self.collectionView reloadData];
    }
}

- (void)globalSearch:(NSString *)searchText {
    
    if (searchText.length == 0) {
        self.searchResult = @[];
        [self.searchDisplayController.searchResultsTableView reloadData];
        return;
    }
//    
//    __weak __typeof(self)weakSelf = self;
//    KLUserPagedResultBlock userPagedBlock = ^(KLUserPagedResult *pagedResult) {
//        
//        NSArray *users = [KLUsersUtils sortUsersByFullname:pagedResult.users];
//        //Remove current user from search result
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.ID != %d", [KLApi instance].currentUser.ID];
//        weakSelf.searchResult = [users filteredArrayUsingPredicate:predicate];
//        [weakSelf.searchDisplayController.searchResultsTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
//        weakSelf.searchOperation = nil;
//        [SVProgressHUD dismiss];
//    };
//    
//    [self.searchDisplayController.searchResultsTableView reloadData];
//    
//    __block NSString *tsearch = [searchText copy];
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//        if ([self.searchDisplayController.searchBar.text isEqualToString:tsearch]) {
//            
//            if (self.searchOperation) {
//                [self.searchOperation cancel];
//                self.searchOperation = nil;
//            }
//            
//            PagedRequest *request = [[PagedRequest alloc] init];
//            request.page = 1;
//            request.perPage = 100;
//            
//            
//            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
//            self.searchOperation = [[KLApi instance].usersService retrieveUsersWithFullName:searchText pagedRequest:request completion:userPagedBlock];
//        }
//    });
}

- (void)setContactRequestsCount:(NSUInteger)contactRequestsCount
{
    if (_contactRequestsCount != contactRequestsCount) {
        _contactRequestsCount = contactRequestsCount;
        if ([self.delegate respondsToSelector:@selector(didChangeContactRequestsCount:)]) {
            [self.delegate didChangeContactRequestsCount:_contactRequestsCount];
        }
    }
}

#pragma mark - UITableViewDataSource


- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    //return (self.searchDisplayController.isActive) ? 2 : 1;
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSArray *users = [self usersAtSections:section];
    if (self.searchDisplayController.isActive) {
        return (users.count > 0) ? users.count : 0;
    }
    //return (users.count > 0) ? users.count : 1;
    return (users.count > 0) ? users.count : 0;
}

- (NSArray *)usersAtSections:(NSInteger)section
{
    return (section == 0) ? self.friendList : self.searchResult;
}

- (KLUser *)userAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *users = [self usersAtSections:indexPath.section];
    KLUser *user = users[indexPath.row];
    
    return user;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *users = [self usersAtSections:indexPath.section];
    
    if (!self.searchDisplayController.isActive) {
        if (users.count == 0) {
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDontHaveAnyFriendsCellIdentifier forIndexPath:indexPath];
            return cell;
        }
    }
    FriendListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFriendsListCellIdentifier forIndexPath:indexPath];
    cell.delegate = self;

    KLUser *user = users[indexPath.row];
    
//    ContactListItem *item = [KLUser contactItemWithUserID:user.ID];
//    cell.contactlistItem = item;
    cell.userData = user;
    
    if(self.searchDisplayController.isActive) {
        cell.searchText = self.searchDisplayController.searchBar.text;
    }
    NSLog(@"%@", user);
    return cell;
}


#pragma mark - UsersListCellDelegate

- (void)usersListCell:(FriendListCell *)cell pressAddBtn:(UIButton *)sender {
    
    NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForCell:cell];
    NSArray *datasource = [self usersAtSections:indexPath.section];
    KLUser *user = datasource[indexPath.row];
    
//    __weak __typeof(self)weakSelf = self;
//    [[KLApi instance] addUserToContactList:user completion:^(BOOL success, QBChatMessage *notification) {
//        if (success) {
//            weakSelf.tUser = user;
////            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
//        }
//    }];
}


#pragma mark - UISearchDisplayController

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self globalSearch:searchString];
    return NO;
}

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    // needed!
//    [self.tableView setDataSource:nil];
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
//    [self.tableView setDataSource:self];
    [self.collectionView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *users = [self usersAtSections:indexPath.section];
    
    if (!self.searchDisplayController.isActive) {
        if (users.count == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDontHaveAnyFriendsCellIdentifier];
            return cell;
        }
    }
    FriendListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendListCell"];
    if ( cell == nil)
    {
        //register
        cell = (FriendListCell*)[[[NSBundle mainBundle] loadNibNamed:@"FriendListCell" owner:nil options:nil] objectAtIndex:0];
    }
    cell.delegate = self;
    
    KLUser *user = users[indexPath.row];
//    
//    QBContactListItem *item = [[KLApi instance] contactItemWithUserID:user.ID];
//    cell.contactlistItem = item;
//    cell.userData = user;
//    
//    if(self.searchDisplayController.isActive) {
//        cell.searchText = self.searchDisplayController.searchBar.text;
//    }
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSArray *users = [self usersAtSections:section];
    
    if (self.searchDisplayController.isActive && section == 1) {
        return (users.count > 0) ? NSLocalizedString(@"KL_STR_ALL_USERS", nil) : nil;
    }
    return (users.count > 0) ? NSLocalizedString(@"KL_STR_CONTACTS", nil) : nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return (self.searchDisplayController.isActive) ? 2 : 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *users = [self usersAtSections:section];
    if (self.searchDisplayController.isActive) {
        return (users.count > 0) ? users.count : 0;
    }
    return (users.count > 0) ? users.count : 1;
}

@end

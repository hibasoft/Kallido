//
//  FriendsListDataSource.h
//  Kaliido
//
//  Created by Daron on 4/3/14.
//

static NSString *const kFriendsListCellIdentifier = @"nearbycollectionview";
static NSString *const kDontHaveAnyFriendsCellIdentifier = @"nearbycollectionview1notusednow";
static NSString *const kFaviroutesListCellIdentifier = @"favouritescollectionview";



@protocol FriendsListDataSourceDelegate <NSObject>

- (void)didChangeContactRequestsCount:(NSUInteger)contactRequestsCount;

@end

@interface FriendsListDataSource : NSObject <UICollectionViewDelegate,UICollectionViewDataSource, UsersListDelegate,UISearchDisplayDelegate,UITableViewDataSource>

@property (nonatomic, assign) BOOL viewIsShowed;
@property (weak, nonatomic) id <FriendsListDataSourceDelegate> delegate;

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView searchDisplayController:(UISearchDisplayController *)searchDisplayController;
- (NSArray *)usersAtSections:(NSInteger)section;
- (KLUser *)userAtIndexPath:(NSIndexPath *)indexPath;
- (void)setFriendList:(NSArray *)friendList;
@end

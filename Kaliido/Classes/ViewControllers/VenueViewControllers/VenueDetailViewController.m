//
//  KLVenueDetailViewController.m
//  Kaliido
//
//  Created by Learco R on 5/24/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import "VenueDetailViewController.h"
#import "KLImageView.h"

#import "KLApi.h"
#import "KLWebService.h"

#import "VenueDetailCheckInTableViewCell.h"
#import "WhoHereCollectionViewCell.h"
@interface VenueDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;

@property (weak, nonatomic) IBOutlet UIImageView *checkInImageView;
@property (weak, nonatomic) IBOutlet UIImageView *whohereImageView;
@property (weak, nonatomic) IBOutlet UIImageView *reviewImageView;
@property (weak, nonatomic) IBOutlet UILabel *checkInLabel;
@property (weak, nonatomic) IBOutlet UILabel *whohereLabel;
@property (weak, nonatomic) IBOutlet UILabel *reviewLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *whohereCollectionView;

@property (weak, nonatomic) IBOutlet UITableView *checkinTableView;
@property (weak, nonatomic) IBOutlet UITableView *reviewTable;



@property (nonatomic, strong) NSArray *peopleArray;


@end

@implementation VenueDetailViewController

static NSString * const reuseIdentifierCheckIn = @"CheckInCell";
static NSString * const reuseIdentifierItem = @"VenueItemCell";

static NSString * const reuseIdentifierWhoHere = @"WhoHereCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.peopleArray = @[@"Benjamin" , @"Learco", @"Robbie", @"Vadim", @"Egor"];

    self.checkinTableView.hidden = false;
    self.whohereCollectionView.hidden = true;
    self.reviewTable.hidden = true;
}

// MARK: button action
- (IBAction)actionCheckIn:(id)sender {
    
    
    self.checkinTableView.hidden = false;
    self.whohereCollectionView.hidden = true;
    self.reviewTable.hidden = true;
    
}
- (IBAction)actionWhoHere:(id)sender {
    
    
    self.checkinTableView.hidden = true;
    self.whohereCollectionView.hidden = false;
    self.reviewTable.hidden = true;
}
- (IBAction)actionReview:(id)sender {
    
    
    self.checkinTableView.hidden = true;
    self.whohereCollectionView.hidden = true;
    self.reviewTable.hidden = false;
}
- (IBAction) actionBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:TRUE];
}
//MARK: UITableView delegate

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
////
//    return 50;
//}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    VenueDetailCheckInTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierCheckIn];
    
    
    
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}



#pragma mark - UICollectionView
-  (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.peopleArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    WhoHereCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierWhoHere forIndexPath:indexPath];
//    cell.delegate = self;
    
//    NSDictionary *userDic = self.peopleArray[indexPath.row];
//    [cell updateData:userDic];
    //    if(self.searchBar.isFirstResponder)
    //        cell.searchText = self.searchBar.text;
    return cell;

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
//    [[KLWebService getInstance] getUserById:(int)[[self.userList[indexPath.row] valueForKey:@"id"] integerValue] withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
//        [SVProgressHUD dismiss];
//        if (success)
//        {
//            KLFriendsDetailsContainerController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"KLFriendsDetailsContainerController"];
//            controller.userDic = response;
//            [self.navigationController pushViewController:controller animated:YES];
//        }
//    }];
}

-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    CGSize cellSize = CGSizeMake(160, 177);
    CGRect rc = [UIScreen mainScreen].bounds;
//    CGFloat scale = rc.size.width/(2*cellSize.width);
    return CGSizeMake((rc.size.width -20)/2, (rc.size.width -20)/2+10);
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

//
//  InterestViewController.m
//  Kaliido
//
//  Created by  Kaliido on 3/8/15.
//  Copyright (c) 2015 Kaliido. All rights reserved.
//

#import "InterestViewController.h"
#import "InterestCollectionViewCell.h"
#import "SubInterestViewController.h"
#import "KLWebService.h"


@interface InterestViewController ()
{
    NSArray *arrNames;
    IBOutlet UICollectionView *cView;
}
@end

@implementation InterestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Interests";
//    arrNames = @[@"Arts & Entertainment", @"Events & Listings",@"Fun & Humor",@"Movies",@"Music",@"Autos & Vehicles",@"Beauty & Fitness",@"Books & Literature",@"Business & Industries",@"Geek",@"Finance",@"Food & Drink",@"Games",@"Hobbies & Leisure",@"Home & Garden",@"Jobs & Education",@"Law & Government",@"News",@"Online Communities",@"People and Society",@"Pets & Animals",@"Spirituality"];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [[KLWebService getInstance] getInterests:^(BOOL success, NSArray *response, NSError *error) {
        [SVProgressHUD dismiss];
        arrNames = response;
        [cView reloadData];
    }];
    if (self.parent != nil)
        self.navigationItem.rightBarButtonItem = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [arrNames count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    InterestCollectionViewCell *cell = (InterestCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"InterestCell" forIndexPath:indexPath];
    cell.lblInterestName.text = [[arrNames objectAtIndex:indexPath.row] valueForKey:@"name"];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.lblInterestName.highlightedTextColor = [UIColor whiteColor];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:70.0/255.0f green:57.0/255.0f blue:139/255.0f alpha:1.0f];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SubInterestViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SubInterestViewController"];
    vc.selectedCategory = [[[arrNames objectAtIndex:indexPath.row] valueForKey:@"id"] integerValue];
    vc.title = [[arrNames objectAtIndex:indexPath.row] valueForKey:@"name"];
    vc.parent = self.parent;
    vc.detailParent = self.detailParent;
    vc.directoryParent = self.directoryParent;
    [self.navigationController pushViewController:vc animated:YES];
}

-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(cView.frame.size.width/2-1, cView.frame.size.width/2-1);
}
@end

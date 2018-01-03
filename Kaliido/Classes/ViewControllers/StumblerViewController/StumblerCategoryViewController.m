//
//  StumblerCategoryViewController.m
//  Kaliido
//
//  Created by  Kaliido on 12/29/15.
//  Copyright © 2015 Kaliido. All rights reserved.
//

#import "StumblerCategoryViewController.h"
#import "InterestCollectionViewCell.h"
#import "StumblerSubCategoryViewController.h"
#import "KLWebService.h"


@interface StumblerCategoryViewController ()
{
    NSArray *arrNames;
    IBOutlet UICollectionView *cView;
}
@end

@implementation StumblerCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO];
    self.title = @"Stumbler Categories";
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [[KLWebService getInstance] getStumblerCategoryAll:^(BOOL success, NSArray *response, NSError *error) {
        [SVProgressHUD dismiss];
        arrNames = response;
        [cView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    StumblerSubCategoryViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"StumblerSubCategoryViewController"];
    vc.selectedCategory = [[[arrNames objectAtIndex:indexPath.row] valueForKey:@"id"] integerValue];
    vc.title = [[arrNames objectAtIndex:indexPath.row] valueForKey:@"name"];
    vc.parent = self.parent;
    [self.navigationController pushViewController:vc animated:YES];
}

-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(cView.frame.size.width/2-1, (cView.frame.size.height-64)/3);
}

@end

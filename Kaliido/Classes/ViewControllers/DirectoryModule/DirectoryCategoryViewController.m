//
//  DirectoryCategoryViewController.m
//  Kaliido
//
//  Learco on 8/2/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import "DirectoryCategoryViewController.h"

#import "DirectoryCategoryCollectionViewCell.h"
#import "DirectoryCreateViewController.h"
#import "KLWebService.h"
#import "CategoryViewModel.h"

@interface DirectoryCategoryViewController ()
{
    NSArray *arrNames;
    IBOutlet UICollectionView *cView;
    NSMutableArray *arContentList;
}
@end

@implementation DirectoryCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO];
    self.title = @"Directory Categories";
    
    arContentList = [@[] mutableCopy];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [arContentList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DirectoryCategoryCollectionViewCell *cell = (DirectoryCategoryCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"DirectoryCategoryCollectionViewCell" forIndexPath:indexPath];
    
    CategoryViewModel *itemVM = [arContentList objectAtIndex:indexPath.row];
    [cell configureCellWithCategoryViewModel:itemVM];
        return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DirectoryCreateViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DirectoryCreateViewController"];
    CategoryViewModel *item = [arContentList objectAtIndex:indexPath.row];

    vc.selectedCategoryId = item.categoryId;
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(cView.frame.size.width/2-1, (cView.frame.size.height-64)/3);
}

@end

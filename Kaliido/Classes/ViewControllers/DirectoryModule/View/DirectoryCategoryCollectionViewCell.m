//
//  DirectoryCategoryCollectionViewCell.m
//  Kaliido
//
//  Learco on 8/2/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import "DirectoryCategoryCollectionViewCell.h"


@interface DirectoryCategoryCollectionViewCell ()

@end

@implementation DirectoryCategoryCollectionViewCell

static NSString * const reuseIdentifier = @"Cell";

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}
- (void)configureCellWithCategoryViewModel:(CategoryViewModel*)categoryItem
{
 
    
    
    self.lblCategoryName.text = categoryItem.categoryName;
    self.lblCategoryName.highlightedTextColor = [UIColor whiteColor];
    
    
    UIImageView* normalImage = [[UIImageView alloc] initWithFrame:self.frame];
    UIImageView* selectedImage = [[UIImageView alloc] initWithFrame:self.frame];
    [normalImage setImage:[UIImage imageNamed:categoryItem.imageUIDStandard]];
    [selectedImage setImage:[UIImage imageNamed:categoryItem.imageUIDStandard]];
    
    
    self.selectedBackgroundView = selectedImage;
    self.backgroundView = normalImage;
    self.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:70.0/255.0f green:57.0/255.0f blue:139/255.0f alpha:1.0f];
    

    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
#warning Incomplete implementation, return the number of sections
    return 0;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of items
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end

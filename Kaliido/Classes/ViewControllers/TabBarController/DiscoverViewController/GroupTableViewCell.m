//
//  GroupTableViewCell.m
//  Kaliido
//
//  Learco on 1/8/17.
//  Copyright © 2017 Kaliido. All rights reserved.
//

#import "GroupTableViewCell.h"
#import "GroupCollectionViewCell.h"
@implementation GroupTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void) setGroupData : (NSMutableArray*) groupArray  {
    mGroupArray = groupArray;
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    [self.collectionView reloadData];
}
    
    
    
    
#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource
    
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
    {
        return [mGroupArray count];
    }
    
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
    {
        GroupCollectionViewCell* cell=(GroupCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"collectiongroup" forIndexPath:indexPath];
        
        GroupModel *itemViewModel = [mGroupArray objectAtIndex:indexPath.row];
        
        if (indexPath.row % 2 == 0) {
            cell.groupImageView.image = [UIImage imageNamed:@"discovertemp3.png"];
        }else
        cell.groupImageView.image = [UIImage imageNamed:@"discovertemp4.png"];
        
        
        cell.groupTitleLabel.text = itemViewModel.groupName;
        cell.groupMemberLabel.text = itemViewModel.memberCount;

        
        return cell;
    }
    
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
    {
        //        if ([(id)delegate respondsToSelector:@selector(didSelectCategoryItemAtIndex:)])
        //        {
        //            [delegate didSelectCategoryItemAtIndex:indexPath.row];
        //        }
    }
    
#pragma mark - UICollectionViewDelegateFlowLayout
    
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
    {
        return CGSizeMake(200, 152);
    }
    
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
    {
        return UIEdgeInsetsMake(10, 10, 10, 10);
    }
    
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
    {
        return 10;
    }
    
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  EventTableViewCell.m
//  Kaliido
//
//  Hiba on 1/8/17.
//  Copyright © 2017 Kaliido. All rights reserved.
//

#import "EventTableViewCell.h"
#import "EventCollectionViewCell.h"
#import "EventModel.h"
@implementation EventTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void) setEventData : (NSMutableArray*) eventArray  {
    mEventArray = [NSMutableArray arrayWithArray:eventArray];
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    [self.collectionView reloadData];
}
    
    
    
    
    
#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource
    
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
    {
        return 1;
    }
    
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
    {
        return [mEventArray count];
    }
    
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
    {
        EventCollectionViewCell* cell=(EventCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"collectionevent" forIndexPath:indexPath];
        
        
        EventModel *itemViewModel = [mEventArray objectAtIndex:indexPath.row];
        
        if (indexPath.row % 2 == 0) {
            cell.eventImageView.image = [UIImage imageNamed:@"discovertemp1.png"];
        }else
            cell.eventImageView.image = [UIImage imageNamed:@"discovertemp2.png"];
        
    
        cell.eventTitleLabel.text = itemViewModel.eventName;
        cell.eventDateLabel.text = itemViewModel.eventDate;
        
        
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
        return CGSizeMake(200, 170);
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

//
//  DirectoryPerkCell.m
//  Kaliido
//
//  Created by Vadim Budnik on 6/28/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import "DirectoryPerkCell.h"
#import "PerksViewModel.h"
#import "PerkCollectionCell.h"
#import "Perk.h"
#import "PerkViewModel.h"

static NSString *perkCollectionCellIdentifier = @"PerkCollectionCell";

@interface DirectoryPerkCell() <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) PerksViewModel *perksModel;
@property (nonatomic, assign) CGFloat cellWidth;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat insetTop;
@property (nonatomic, assign) CGFloat insetLeft;
@property (nonatomic, assign) CGFloat insetRight;
@property (nonatomic, assign) CGFloat insetBottom;
@property (nonatomic, assign) CGFloat cellSpacing;

- (IBAction)didTapOnViewAll:(id)sender;

@end

@implementation DirectoryPerkCell

@synthesize delegate;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self configureView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureView
{
    _insetTop = 5.0f;
    _insetLeft = 5.0f;
    _insetBottom = 5.0f;
    _insetRight = 5.0f;
    
    _cellSpacing = 5.0f/2.0f;
    
    _cellHeight = constraintCollectionViewHeight.constant-self.insetTop-self.insetBottom;
    _cellWidth = _cellHeight-40.0f;
    
    [cvList registerNib:[UINib nibWithNibName:perkCollectionCellIdentifier bundle:nil] forCellWithReuseIdentifier:perkCollectionCellIdentifier];
    
    btViewAll.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
    
    btViewAll.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    btViewAll.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    btViewAll.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
}

#pragma mark - Actions

- (IBAction)didTapOnViewAll:(id)sender
{
    if ([(id)delegate respondsToSelector:@selector(didRequestToViewAllPerks)])
    {
        [delegate didRequestToViewAllPerks];
    }
}

#pragma mark - Configure Cell With PerkViewModel

- (void)configureCellWithPerksViewModel:(PerksViewModel*)perksModel
{
    self.perksModel = perksModel;
    
    [cvList reloadData];
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.perksModel.arPerks count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PerkCollectionCell* cell=(PerkCollectionCell*)[collectionView dequeueReusableCellWithReuseIdentifier:perkCollectionCellIdentifier forIndexPath:indexPath];
    
    Perk *item = [self.perksModel.arPerks objectAtIndex:indexPath.row];
    PerkViewModel *itemViewModel = [[PerkViewModel alloc] initWithPerk:item];
    
    [cell configureViewWithViewModel:itemViewModel];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([(id)delegate respondsToSelector:@selector(didSelectPerkItemAtIndex:)])
    {
        [delegate didSelectPerkItemAtIndex:indexPath.row];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(_cellWidth, _cellHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(_insetTop, _insetLeft, _insetBottom, _insetRight);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return _cellSpacing;
}

@end

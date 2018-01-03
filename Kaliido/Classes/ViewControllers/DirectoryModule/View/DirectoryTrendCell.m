//
//  DirectoryTrendCell.m
//  Kaliido
//
//  Created by Vadim Budnik on 6/26/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import "DirectoryTrendCell.h"
#import "TrendViewModel.h"
#import "TrendCollectionCell.h"
#import "TrendPage.h"
#import "TrendPageViewModel.h"

static NSString *trendCollectionCellIdentifier = @"TrendCollectionCell";

@interface DirectoryTrendCell() <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) TrendViewModel *trendModel;
@property (nonatomic, assign) CGFloat cellWidth;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat insetTop;
@property (nonatomic, assign) CGFloat insetLeft;
@property (nonatomic, assign) CGFloat insetRight;
@property (nonatomic, assign) CGFloat insetBottom;
@property (nonatomic, assign) CGFloat cellSpacing;

- (IBAction)didTapOnViewAll:(id)sender;

@end

@implementation DirectoryTrendCell

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
    _cellWidth = _cellHeight*1.6;
    
    [cvList registerNib:[UINib nibWithNibName:trendCollectionCellIdentifier bundle:nil] forCellWithReuseIdentifier:trendCollectionCellIdentifier];
    
    btViewAll.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
    
    btViewAll.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    btViewAll.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    btViewAll.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
}

#pragma mark - Actions

- (IBAction)didTapOnViewAll:(id)sender
{
    if ([(id)delegate respondsToSelector:@selector(didRequestToViewAllTrendingPages)])
    {
        [delegate didRequestToViewAllTrendingPages];
    }
}

#pragma mark - Configure Cell With TrendViewModel

- (void)configureCellWithTrendViewModel:(TrendViewModel*)trend
{
    self.trendModel = trend;
    
    [cvList reloadData];
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.trendModel.arTrends count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TrendCollectionCell* cell=(TrendCollectionCell*)[collectionView dequeueReusableCellWithReuseIdentifier:trendCollectionCellIdentifier forIndexPath:indexPath];
    
    TrendPage *item = [self.trendModel.arTrends objectAtIndex:indexPath.row];
    TrendPageViewModel *itemPage = [[TrendPageViewModel alloc] initWithTrendPage:item];
    
    [cell configureViewWithViewModel:itemPage];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([(id)delegate respondsToSelector:@selector(didSelectTrendingPageItemAtIndex:)])
    {
        [delegate didSelectTrendingPageItemAtIndex:indexPath.row];
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

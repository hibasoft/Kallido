//
//  DirectoryStumblerCell.m
//  Kaliido
//
//  Created by Vadim Budnik on 6/29/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import "DirectoryStumblerCell.h"
#import "StumblersViewModel.h"
#import "StumblerCollectionCell.h"
#import "Stumbler.h"
#import "StumblerViewModel.h"

static NSString *stumblerCollectionCellIdentifier = @"StumblerCollectionCell";

@interface DirectoryStumblerCell() <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) StumblersViewModel *stumblersModel;
@property (nonatomic, assign) CGFloat cellWidth;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat insetTop;
@property (nonatomic, assign) CGFloat insetLeft;
@property (nonatomic, assign) CGFloat insetRight;
@property (nonatomic, assign) CGFloat insetBottom;
@property (nonatomic, assign) CGFloat cellSpacing;

- (IBAction)didTapOnViewAll:(id)sender;

@end

@implementation DirectoryStumblerCell

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
    
    [cvList registerNib:[UINib nibWithNibName:stumblerCollectionCellIdentifier bundle:nil] forCellWithReuseIdentifier:stumblerCollectionCellIdentifier];
    
    btViewAll.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
    
    btViewAll.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    btViewAll.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    btViewAll.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
}

#pragma mark - Actions

- (IBAction)didTapOnViewAll:(id)sender
{
    if ([(id)delegate respondsToSelector:@selector(didRequestToViewAllStumblers)])
    {
        [delegate didRequestToViewAllStumblers];
    }
}

#pragma mark - Configure Cell With FollowersViewModel

- (void)configureCellWithStumblersViewModel:(StumblersViewModel*)stumblersModel
{
    self.stumblersModel = stumblersModel;
    
    [cvList reloadData];
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.stumblersModel.arStumblers count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    StumblerCollectionCell* cell=(StumblerCollectionCell*)[collectionView dequeueReusableCellWithReuseIdentifier:stumblerCollectionCellIdentifier forIndexPath:indexPath];
    
    Stumbler *item = [self.stumblersModel.arStumblers objectAtIndex:indexPath.row];
    StumblerViewModel *itemViewModel = [[StumblerViewModel alloc] initWithStumbler:item];
    
    [cell configureViewWithViewModel:itemViewModel];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([(id)delegate respondsToSelector:@selector(didSelectStumblerItemAtIndex:)])
    {
        [delegate didSelectStumblerItemAtIndex:indexPath.row];
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

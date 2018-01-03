//
//  DirectoryTrendCell.h
//  Kaliido
//
//  Created by Vadim Budnik on 6/26/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DirectoryTrendCellDelegate <NSObject>

@optional

- (void)didSelectTrendingPageItemAtIndex:(NSInteger)selectedIndex;
- (void)didRequestToViewAllTrendingPages;

@end

@class TrendViewModel;

@interface DirectoryTrendCell : UITableViewCell
{
    IBOutlet UIButton *btViewAll;
    IBOutlet UICollectionView *cvList;
    
    IBOutlet NSLayoutConstraint *constraintCollectionViewHeight;
}

@property (assign) id<DirectoryTrendCellDelegate> delegate;

- (void)configureCellWithTrendViewModel:(TrendViewModel*)trend;

@end

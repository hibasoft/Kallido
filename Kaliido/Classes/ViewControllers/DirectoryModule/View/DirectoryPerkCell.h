//
//  DirectoryPerkCell.h
//  Kaliido
//
//  Created by Vadim Budnik on 6/28/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DirectoryPerkCellDelegate <NSObject>

@optional

- (void)didSelectPerkItemAtIndex:(NSInteger)selectedIndex;
- (void)didRequestToViewAllPerks;

@end

@class PerksViewModel;

@interface DirectoryPerkCell : UITableViewCell
{
    IBOutlet UILabel *lbTitle;
    IBOutlet UIButton *btViewAll;
    IBOutlet UICollectionView *cvList;
    
    IBOutlet NSLayoutConstraint *constraintCollectionViewHeight;
}

@property (assign) id<DirectoryPerkCellDelegate> delegate;

- (void)configureCellWithPerksViewModel:(PerksViewModel*)perksModel;

@end

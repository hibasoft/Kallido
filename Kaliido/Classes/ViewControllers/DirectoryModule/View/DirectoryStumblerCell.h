//
//  DirectoryStumblerCell.h
//  Kaliido
//
//  Created by Vadim Budnik on 6/29/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DirectoryStumblerCellDelegate <NSObject>

@optional

- (void)didSelectStumblerItemAtIndex:(NSInteger)selectedIndex;
- (void)didRequestToViewAllStumblers;

@end

@class StumblersViewModel;

@interface DirectoryStumblerCell : UITableViewCell
{
    IBOutlet UILabel *lbTitle;
    IBOutlet UIButton *btViewAll;
    IBOutlet UICollectionView *cvList;
    
    IBOutlet NSLayoutConstraint *constraintCollectionViewHeight;
}

@property (assign) id<DirectoryStumblerCellDelegate> delegate;

- (void)configureCellWithStumblersViewModel:(StumblersViewModel*)stumblersModel;


@end

//
//  DirectoryFollowerCell.h
//  Kaliido
//
//  Created by Vadim Budnik on 6/29/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DirectoryFollowerCellDelegate <NSObject>

@optional

- (void)didSelectFollowerItemAtIndex:(NSInteger)selectedIndex;
- (void)didRequestToViewAllFollowers;

@end

@class FollowersViewModel;

@interface DirectoryFollowerCell : UITableViewCell
{
    IBOutlet UILabel *lbTitle;
    IBOutlet UIButton *btViewAll;
    IBOutlet UICollectionView *cvList;
    
    IBOutlet NSLayoutConstraint *constraintCollectionViewHeight;
}

@property (assign) id<DirectoryFollowerCellDelegate> delegate;

- (void)configureCellWithFollowersViewModel:(FollowersViewModel*)followersModel;


@end

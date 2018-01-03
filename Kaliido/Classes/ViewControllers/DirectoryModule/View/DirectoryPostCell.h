//
//  DirectoryPostCell.h
//  Kaliido
//
//  Created by Vadim Budnik on 7/1/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DirectoryPostCellDelegate <NSObject>

@optional

- (void)didSelectPostPageItemAtIndex:(NSInteger)selectedIndex;
- (void)didRequestToViewAllPostPages;

@end

@class PostPagesViewModel;

@interface DirectoryPostCell : UITableViewCell
{
    IBOutlet UIButton *btViewAll;
    IBOutlet UIView *vwNoResult;
    IBOutlet UIView *vwPosts;
    IBOutlet UITableView *tbPostPageList;
    
    IBOutlet NSLayoutConstraint *constraintPostViewHeight;
    IBOutlet NSLayoutConstraint *constraintNoPostViewHeight;
}

@property (assign) id<DirectoryPostCellDelegate> delegate;

- (void)configureCellWithPostPagesViewModel:(PostPagesViewModel*)postPageModel;


@end

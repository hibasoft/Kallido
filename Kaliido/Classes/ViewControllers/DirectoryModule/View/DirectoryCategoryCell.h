//
//  DirectoryCategoryCell.h
//  Kaliido
//
//  Created by Vadim Budnik on 6/28/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DirectoryCategoryCellDelegate <NSObject>

@optional

- (void)didSelectCategoryItemAtIndex:(NSInteger)selectedIndex;
- (void)didRequestToViewAllCategories;

@end

@class CategoriesViewModel;

@interface DirectoryCategoryCell : UITableViewCell
{
    IBOutlet UILabel *lbTitle;
    IBOutlet UIButton *btViewAll;
    IBOutlet UICollectionView *cvList;
    
    IBOutlet NSLayoutConstraint *constraintCollectionViewHeight;
}

@property (assign) id<DirectoryCategoryCellDelegate> delegate;

- (void)configureCellWithCategoriesViewModel:(CategoriesViewModel*)categoriesModel;


@end

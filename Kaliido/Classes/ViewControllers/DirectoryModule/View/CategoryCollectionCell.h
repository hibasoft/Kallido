//
//  CategoryCollectionCell.h
//  Kaliido
//
//  Created by Vadim Budnik on 6/28/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CategoryViewModel;

@interface CategoryCollectionCell : UICollectionViewCell
{
    IBOutlet UILabel *lbTitle;
    IBOutlet UIImageView *ivImage;
}

- (void)configureViewWithViewModel:(CategoryViewModel*)categoryModel;

@end

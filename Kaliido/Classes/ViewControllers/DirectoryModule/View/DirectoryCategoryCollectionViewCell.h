//
//  DirectoryCategoryCollectionViewCell.h
//  Kaliido
//
//  Hiba on 8/2/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryViewModel.h"
@interface DirectoryCategoryCollectionViewCell : UICollectionViewCell

@property (nonatomic, retain) IBOutlet UILabel* lblCategoryName;

- (void)configureCellWithCategoryViewModel:(CategoryViewModel*)categoryItem;
@end

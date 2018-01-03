//
//  DirectoryTableCell.h
//  Kaliido
//
//  Created by Vadim Budnik on 6/23/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CategoryViewModel;

@interface DirectoryCategoryTableCell : UITableViewCell
{
    IBOutlet UILabel *lbTitle;
}

- (void)configureCellWithCategoryViewModel:(CategoryViewModel*)categoryItem;

@end

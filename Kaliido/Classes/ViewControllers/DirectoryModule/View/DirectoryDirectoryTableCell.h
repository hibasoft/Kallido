//
//  DirectoryDirectoryTableCell.h
//  Kaliido
//
//  Created by Vadim Budnik on 6/23/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DirectoryViewModel;

@interface DirectoryDirectoryTableCell : UITableViewCell
{
    IBOutlet UILabel *lbTitle;
    IBOutlet UILabel *lbHeadline;
    IBOutlet UIImageView *ivLogo;
}

- (void)configureCellWithDirectoryViewModel:(DirectoryViewModel*)directoryItem;

@end

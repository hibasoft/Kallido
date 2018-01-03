//
//  PerkCollectionCell.h
//  Kaliido
//
//  Created by Vadim Budnik on 6/28/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PerkViewModel;

@interface PerkCollectionCell : UICollectionViewCell
{
    IBOutlet UILabel *lbTitle;
    IBOutlet UIImageView *ivImage;
}

- (void)configureViewWithViewModel:(PerkViewModel*)perkModel;

@end

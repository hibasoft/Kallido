//
//  StumblerCollectionCell.h
//  Kaliido
//
//  Created by Vadim Budnik on 6/29/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StumblerViewModel;

@interface StumblerCollectionCell : UICollectionViewCell
{
    IBOutlet UILabel *lbTitle;
    IBOutlet UIImageView *ivImage;
}

- (void)configureViewWithViewModel:(StumblerViewModel*)stumblerViewModel;

@end

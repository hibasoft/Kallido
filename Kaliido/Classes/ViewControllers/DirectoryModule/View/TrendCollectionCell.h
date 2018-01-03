//
//  TrendCollectionCell.h
//  Kaliido
//
//  Created by Vadim Budnik on 6/28/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TrendPageViewModel;

@interface TrendCollectionCell : UICollectionViewCell
{
    IBOutlet UIImageView *ivCover;
    IBOutlet UIImageView *ivProfile;
    IBOutlet UILabel *lbTitle;
}

- (void)configureViewWithViewModel:(TrendPageViewModel*)trendPage;

@end

//
//  EventCollectionViewCell.h
//  Kaliido
//
//  Hiba on 1/9/17.
//  Copyright © 2017 Kaliido. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventCollectionViewCell : UICollectionViewCell
    @property (weak, nonatomic) IBOutlet UIImageView *eventImageView;
    @property (weak, nonatomic) IBOutlet UILabel *eventTitleLabel;
    @property (weak, nonatomic) IBOutlet UILabel *eventDateLabel;

@end

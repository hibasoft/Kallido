//
//  GroupCollectionViewCell.h
//  Kaliido
//
//  Hiba on 1/9/17.
//  Copyright © 2017 Kaliido. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupCollectionViewCell : UICollectionViewCell
    @property (weak, nonatomic) IBOutlet UIImageView *groupImageView;
    @property (weak, nonatomic) IBOutlet UILabel *groupTitleLabel;
    @property (weak, nonatomic) IBOutlet UILabel *groupMemberLabel;

@end

//
//  KLCollectionViewCell.h
//  Kaliido
//
//  Created by  Kaliido on 1/19/15.
//  Copyright (c) 2015 Kaliido. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KLImageView;

@interface KLCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) id userData;
//@property (strong, nonatomic) QBContactListItem *contactlistItem;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet KLImageView *klImageView;

- (void)setUserImageWithUrl:(NSURL *)userImageUrl;
- (void)setUserImage:(UIImage *)image withKey:(NSString *)key;

@end

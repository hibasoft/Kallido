//
//  KLTableViewCell.h
//  Kaliido
//
//  Created by Daron on 11.07.14.
//  Copyright (c) 2014 Kaliido. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KLImageView;

@interface KLTableViewCell : UITableViewCell 

@property (strong, nonatomic) id userData;
//@property (strong, nonatomic) QBContactListItem *contactlistItem;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet KLImageView *klImageView;

- (void)setUserImageWithUrl:(NSURL *)userImageUrl;
- (void)setUserImage:(UIImage *)image withKey:(NSString *)key;
- (void)setUserImage:(UIImage *)image;

@end

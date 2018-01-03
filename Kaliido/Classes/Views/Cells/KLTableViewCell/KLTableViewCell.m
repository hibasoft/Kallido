//
//  KLTableViewCell.m
//  Kaliido
//
//  Created by Daron on 11.07.14.
//  Copyright (c) 2014 Kaliido. All rights reserved.
//

#import "KLTableViewCell.h"
#import "KLImageView.h"

@interface KLTableViewCell()

@end

@implementation KLTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.klImageView.imageViewType = KLImageViewTypeCircle;
}

- (void)setUserImageWithUrl:(NSURL *)userImageUrl {
    
    UIImage *placeholder = [UIImage imageNamed:@"upic-placeholder"];
    
    [self.klImageView setImageWithURL:userImageUrl
                          placeholder:placeholder
                              options:SDWebImageHighPriority
                             progress:^(NSInteger receivedSize, NSInteger expectedSize) {}
                       completedBlock:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {}];
}
- (void)setUserImage:(UIImage *)image
{
    self.klImageView.image = image;
}
- (void)setUserImage:(UIImage *)image withKey:(NSString *)key {
    
    if (!image) {
        image = [UIImage imageNamed:@"upic-placeholder"];
    }
    
    [self.klImageView sd_setImage:image withKey:key];
}

@end

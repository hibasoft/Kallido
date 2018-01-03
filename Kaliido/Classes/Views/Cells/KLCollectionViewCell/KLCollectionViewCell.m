//
//  KLCollectionViewCell.m
//  Kaliido
//
//  Created by  Kaliido on 1/19/15.
//  Copyright (c) 2015 Kaliido. All rights reserved.
//

#import "KLCollectionViewCell.h"
#import "KLImageView.h"

@interface KLCollectionViewCell()

@end

@implementation KLCollectionViewCell

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

- (void)setUserImage:(UIImage *)image withKey:(NSString *)key {
    
    if (!image) {
        image = [UIImage imageNamed:@"upic-placeholder"];
    }
    
    [self.klImageView sd_setImage:image withKey:key];
}

@end

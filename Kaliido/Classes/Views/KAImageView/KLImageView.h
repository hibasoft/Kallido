//
//  KLImageView.h
//  Kaliido
//
//  Created by Daron on 27.06.14.
//  Copyright (c) 2014 Kaliido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImageManager.h"

typedef NS_ENUM(NSUInteger, KLImageViewType) {
    KLImageViewTypeNone,
    KLImageViewTypeCircle,
    KLImageViewTypeSquare
};

@interface KLImageView : UIImageView
/**
 Default KLUserImageViewType KLUserImageViewTypeNone
 */
@property (assign, nonatomic) KLImageViewType imageViewType;

- (void)sd_setImage:(UIImage *)image withKey:(NSString *)key;
- (void)setImageWithURL:(NSURL *)url
            placeholder:(UIImage *)placehoder
                options:(SDWebImageOptions)options
               progress:(SDWebImageDownloaderProgressBlock)progress
         completedBlock:(SDWebImageCompletionBlock)completedBlock;
@end

//
//  NearbyUserCollectionViewCell.h
//  Kaliido
//
//  Created by  Kaliido on 9/2/15.
//  Copyright (c) 2015 Kaliido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KLImageView.h"
@interface NearbyUserCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) NSString *searchText;
@property (weak, nonatomic) IBOutlet KLImageView *klImageView;

@property (weak, nonatomic) id <UsersListDelegate>delegate;
-(void)updateData:(NSDictionary*)userDic;

- (void)setUserImageWithUrl:(NSURL *)userImageUrl;
- (void)setUserImage:(UIImage *)image withKey:(NSString *)key;
@end

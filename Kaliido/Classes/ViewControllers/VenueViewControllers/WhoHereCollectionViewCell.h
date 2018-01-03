//
//  WhoHereCollectionViewCell.h
//  Kaliido
//
//  Created by Learco R on 5/25/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WhoHereCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) NSString *searchText;

-(void)updateData:(NSDictionary*)userDic;

- (void)setUserImageWithUrl:(NSURL *)userImageUrl;
- (void)setUserImage:(UIImage *)image withKey:(NSString *)key;
@end


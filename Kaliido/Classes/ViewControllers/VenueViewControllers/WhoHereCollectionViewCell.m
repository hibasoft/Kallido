//
//  WhoHereCollectionViewCell.m
//  Kaliido
//
//  Created by Hiba R on 5/25/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import "WhoHereCollectionViewCell.h"
#import "KLImageView.h"
#import "KLApi.h"
@interface WhoHereCollectionViewCell()

@property (strong, nonatomic) id userData;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *addToFriendsButton;
@property (weak, nonatomic) IBOutlet UIButton *btnOnlineCircle;
@property (weak, nonatomic) IBOutlet KLImageView *klImageView;
@property (assign, nonatomic) BOOL online;
@property (assign, nonatomic) BOOL isFriend;

@end

@implementation WhoHereCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    /*isFriend - YES*/
    _isFriend = NO;
    self.addToFriendsButton.selected = self.isFriend;
    self.klImageView.imageViewType = KLImageViewTypeSquare;
}

- (void)setSearchText:(NSString *)searchText {
    
    _searchText = searchText;
    if (_searchText.length > 0) {
        NSString *fullName = self.titleLabel.text;
        
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:fullName];
        [text addAttribute: NSForegroundColorAttributeName
                     value:[UIColor redColor]
                     range:[fullName.lowercaseString rangeOfString:searchText.lowercaseString]];
        
        self.titleLabel.attributedText = text;
    }
}

-(void)updateData:(NSDictionary*)userDic
{
    __weak __typeof(self)weakSelf = self;
    self.btnOnlineCircle.tag = [[userDic valueForKey:@"quickbloxUserId"] integerValue];
    self.btnOnlineCircle.selected = YES;
    
    
    
    NSDictionary *dic = [userDic valueForKey:@"relations"];
    if (dic != nil && ![dic isEqual:[NSNull null]])
        self.addToFriendsButton.selected = [[[userDic valueForKey:@"relations"] valueForKey:@"isFavorite"] boolValue];
    self.titleLabel.text =[userDic valueForKey:@"fullName"];
    
    NSString *photoUID = [userDic valueForKey:@"photoUID"];
    if (photoUID == nil ||[photoUID isEqual:[NSNull null]])
        photoUID = nil;
    NSURL *avatarUrl = [NSURL URLWithString:photoUID];
    //    KLUser *user = [[KLApi instance] userWithID:[[userDic valueForKey:@"quickbloxUserId"] integerValue]];
    //    NSURL *avatarUrl = [UsersUtils userAvatarURL:user];
    [self setUserImageWithUrl:avatarUrl];
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
#pragma mark - Actions

- (IBAction)pressAddBtn:(UIButton *)sender {
    
    
}

@end


//
//  NearbyUserCollectionViewCell.m
//  Kaliido
//
//  Created by  Kaliido on 9/2/15.
//  Copyright (c) 2015 Kaliido. All rights reserved.
//

#import "NearbyUserCollectionViewCell.h"

#import "KLApi.h"

@interface NearbyUserCollectionViewCell()
@property (strong, nonatomic) id userData;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *addToFriendsButton;
@property (weak, nonatomic) IBOutlet UIButton *btnOnlineCircle;
@property (assign, nonatomic) BOOL online;
@property (assign, nonatomic) BOOL isFriend;

@end

@implementation NearbyUserCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.contentView layoutIfNeeded];
    self.klImageView.layer.cornerRadius = self.klImageView.frame.size.width / 2;
    
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
    NSString* ejabberdUserId = [NSString stringWithFormat:@"%@", [userDic valueForKey:@"quickbloxUserId"]];
                                
    NSString* statusOfUser = [[KLXMPPTool sharedInstance].friendOnlineDict objectForKey:ejabberdUserId];
    
    if ([statusOfUser isEqualToString:@"online"]) {
        self.btnOnlineCircle.selected = YES;
    }else
        self.btnOnlineCircle.selected = NO;
    
    NSDictionary *dic = [userDic valueForKey:@"relations"];
    if (dic != nil && ![dic isEqual:[NSNull null]])
        self.addToFriendsButton.selected = [[[userDic valueForKey:@"relations"] valueForKey:@"isFavorite"] boolValue];
    self.titleLabel.text =[userDic valueForKey:@"fullName"];
    
    NSString *photoUID = [userDic valueForKey:@"photoUID"];
    if (photoUID == nil ||[photoUID isEqual:[NSNull null]])
        photoUID = nil;
    NSURL *avatarUrl = [NSURL URLWithString:photoUID];

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
    
    if ([self.delegate respondsToSelector:@selector(usersListCell:pressAddBtn:)]) {
        [self.delegate usersListCell:self pressAddBtn:sender];
    }
}

@end


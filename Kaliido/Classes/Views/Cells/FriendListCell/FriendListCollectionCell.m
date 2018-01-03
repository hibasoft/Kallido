//
//  FriendListCell.m
//  Kaliido
//
//  Created by Daron on 25/02/2014.
//  Copyright (c) 2014 Kaliido. All rights reserved.
//

#import "FriendListCollectionCell.h"
#import "KLImageView.h"
#import "KLApi.h"

@interface FriendListCollectionCell()

@property (weak, nonatomic) IBOutlet UIImageView *onlineCircle;
@property (weak, nonatomic) IBOutlet UIButton *addToFriendsButton;
@property (weak, nonatomic) IBOutlet UIButton *btnOnlineCircle;
@property (assign, nonatomic) BOOL isFriend;
@property (assign, nonatomic) BOOL online;

@end

@implementation FriendListCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    /*isFriend - YES*/
    _isFriend = YES;
    self.addToFriendsButton.hidden = self.isFriend;
    /*isOnlien - NO*/
    self.onlineCircle.hidden = YES;
    self.descriptionLabel.text = NSLocalizedString(@"KL_STR_OFFLINE", nil);
}

- (void)setUserData:(id)userData {
    [super setUserData:userData];
    
    KLUser *user = userData;
    self.titleLabel.text = (user.fullName.length == 0) ? @"" : user.fullName;
    NSURL *avatarUrl = [KLUsersUtils userAvatarURL:user];
    [self setUserImageWithUrl:avatarUrl];
}

- (void)setOnline:(BOOL)online {
    
    KLUser *user = self.userData;
    online = (user.ID == KLUser.currentUser.ID) ? YES : online;
    
    if (_online != online) {
        _online = online;
    }
    //self.onlineCircle.hidden = !online;
    self.btnOnlineCircle.selected = !online;
}


- (void)setIsFriend:(BOOL)isFriend {
    
    KLUser *user = self.userData;
    isFriend = (user.ID == KLUser.currentUser.ID) ? YES : isFriend;
    
    _isFriend = isFriend;
    
    self.addToFriendsButton.hidden = isFriend;
    if (!_isFriend) {
        self.descriptionLabel.text = @"";
    }
}

- (void)setSearchText:(NSString *)searchText {
    
    _searchText = searchText;
    if (_searchText.length > 0) {
        
        KLUser *user = self.userData;
        NSString *fullName = user.fullName;
        
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:fullName];
        [text addAttribute: NSForegroundColorAttributeName
                     value:[UIColor redColor]
                     range:[fullName.lowercaseString rangeOfString:searchText.lowercaseString]];
        
        self.titleLabel.attributedText = text;
    }
}

#pragma mark - Actions

- (IBAction)pressAddBtn:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(usersListCell:pressAddBtn:)]) {
        [self.delegate usersListCell:self pressAddBtn:sender];
    }
}

@end

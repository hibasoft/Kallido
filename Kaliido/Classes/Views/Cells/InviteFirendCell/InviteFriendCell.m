//
//  InviteFriendsCell.m
//  Kaliido
//
//  Created by Daron on 24.03.14.
//  Copyright (c) 2014 Kaliido. All rights reserved.
//

#import "InviteFriendCell.h"
#import "ABPerson.h"
#import "KLApi.h"

@interface InviteFriendCell()

@property (weak, nonatomic) IBOutlet UIImageView *activeCheckbox;

@end

@implementation InviteFriendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.activeCheckbox.hidden = YES;
}

- (void)setUserData:(id)userData {
    
    [super setUserData:userData];
    
    if ([userData isKindOfClass:ABPerson.class]) {
        [self configureWithAdressaddressBookUser:userData];
    }else if ([userData isKindOfClass:[KLUser class]]) {

        KLUser *user = userData;
        self.titleLabel.text = (user.fullName.length == 0) ? @"" : user.fullName;
        NSURL *avatarUrl = [NSURL URLWithString:user.avatarURL];
        [self setUserImageWithUrl:avatarUrl];
    }
}
//
//- (void)configureWithFBGraphUser:(NSDictionary<FBGraphUser> *)user {
//    
//    self.titleLabel.text = [NSString stringWithFormat:@"%@ %@", user.first_name, user.last_name];
//    NSURL *url = [[KLApi instance] fbUserImageURLWithUserID:user.id];
//    [self setUserImageWithUrl:url];
//    self.descriptionLabel.text = NSLocalizedString(@"KL_STR_FACEBOOK", nil);
//}

- (void)configureWithAdressaddressBookUser:(ABPerson *)addressBookUser {
    
    self.titleLabel.text = addressBookUser.fullName;
    self.descriptionLabel.text = NSLocalizedString(@"KL_STR_CONTACT_LIST", nil);
    
    UIImage *image = addressBookUser.image;
    [self setUserImage:image withKey:addressBookUser.fullName];
}

- (void)setCheck:(BOOL)check {
    
    if (_check != check) {
        _check = check;
        self.activeCheckbox.hidden = !check;
    }
}

#pragma mark - Actions

- (IBAction)pressCheckBox:(id)sender {

    self.check ^= 1;
    [self.delegate containerView:self didChangeState:sender];
}

@end

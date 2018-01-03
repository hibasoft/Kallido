//
//  PostPageTableCell.m
//  Kaliido
//
//  Created by Phoenix on 7/1/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import "PostPageTableCell.h"
#import "PostPageViewModel.h"

@implementation PostPageTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self configureView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureView
{
    ivAvatar.clipsToBounds = YES;
    ivAvatar.contentMode = UIViewContentModeScaleAspectFill;
    ivAvatar.layer.cornerRadius = ivAvatar.frame.size.width/2;
    
    self.clipsToBounds = YES;
}

#pragma mark - Configure Cell With PostPageViewModel

- (void)configureCellWithPostPageViewModel:(PostPageViewModel*)pageViewModel
{
    lbName.text = pageViewModel.userName;
    lbComment.text = pageViewModel.comment;
    lbTime.text = pageViewModel.postedAt;
    
    ivAvatar.image = [UIImage imageNamed:pageViewModel.userAvatarURL];
}

@end

//
//  PostPageTableCell.h
//  Kaliido
//
//  Created by Phoenix on 7/1/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PostPageViewModel;

@interface PostPageTableCell : UITableViewCell
{
    IBOutlet UIImageView *ivAvatar;
    IBOutlet UILabel *lbName;
    IBOutlet UILabel *lbTime;
    IBOutlet UILabel *lbComment;
}

- (void)configureCellWithPostPageViewModel:(PostPageViewModel*)pageViewModel;

@end

//
//  DirectoryDetailHeader.h
//  Kaliido
//
//  Created by Vadim Budnik on 6/29/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomView.h"
#import "DirectoryViewModel.h"

@protocol DirectoryDetailHeaderDelegate <NSObject>

@optional

- (void)didRequestToChangeCoverPicture;
- (void)didRequestToChangeProfilePicture;

@end

@interface DirectoryDetailHeader : CustomView
{
    IBOutlet UIImageView *ivCover;
    IBOutlet UIButton *btCover;
    IBOutlet UIImageView *ivBookmark;
    IBOutlet UIImageView *ivProfile;
    IBOutlet UIButton *btProfile;
    IBOutlet UIButton *btFollow;
    IBOutlet UILabel *lbTitle;
    IBOutlet UILabel *lbSubtitle;
    IBOutlet UILabel *lbDescription;
    
    IBOutlet NSLayoutConstraint *constraintCoverHeight;
    IBOutlet NSLayoutConstraint *constraintDescriptionHeight;
}

@property (assign) id<DirectoryDetailHeaderDelegate> delegate;

- (void)configureViewWithViewModel:(DirectoryViewModel*)directoryModel;
- (void)replaceCoverPictureWith:(NSString*)coverPictureUrl;
- (void)replaceProfilePicturewith:(NSString*)profilePictureUrl;



@end

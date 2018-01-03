//
//  DirectoryDetailHeader.m
//  Kaliido
//
//  Created by Vadim Budnik on 6/29/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import "DirectoryDetailHeader.h"
#import "DirectoryViewModel.h"

@interface DirectoryDetailHeader()

- (IBAction)didTapOnChangeCoverPicture:(id)sender;
- (IBAction)didTapOnChangeProfilePicture:(id)sender;

@end

@implementation DirectoryDetailHeader

@synthesize delegate;

#pragma mark - Initialization

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configureView];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureView];
    }
    
    return self;
}

#pragma mark - Actions

- (IBAction)didTapOnChangeCoverPicture:(id)sender
{
    if ([(id)delegate respondsToSelector:@selector(didRequestToChangeCoverPicture)])
    {
        [delegate didRequestToChangeCoverPicture];
    }
}

- (IBAction)didTapOnChangeProfilePicture:(id)sender
{
    if ([(id)delegate respondsToSelector:@selector(didRequestToChangeProfilePicture)])
    {
        [delegate didRequestToChangeProfilePicture];
    }
}

#pragma mark - Configure View

- (void)configureView
{
    ivCover.clipsToBounds = YES;
    ivCover.contentMode = UIViewContentModeScaleAspectFill;
    
    ivProfile.clipsToBounds = YES;
    ivProfile.contentMode = UIViewContentModeScaleAspectFill;
    ivProfile.layer.cornerRadius = 0.0f;
    ivProfile.layer.borderColor = [[UIColor whiteColor] CGColor];
    ivProfile.layer.borderWidth = 2.0f;
    
    self.clipsToBounds = YES;
}

- (void)configureViewWithViewModel:(DirectoryViewModel*)directoryModel
{
    ivCover.image = [UIImage imageNamed:directoryModel.coverImageURL];
    ivProfile.image = [UIImage imageNamed:directoryModel.profileImageURL];
    
    if (directoryModel.directoryType == 1)
    {
        ivBookmark.hidden = NO;
    }
    else
    {
        ivBookmark.hidden = YES;
    }
    
    lbTitle.text = directoryModel.directoryName;
    lbSubtitle.text = directoryModel.directoryLocation;
    lbDescription.text = directoryModel.directoryDescription;
}

- (void)replaceCoverPictureWith:(NSString*)coverPictureUrl
{
    ivCover.image = [UIImage imageNamed:coverPictureUrl];
}

- (void)replaceProfilePicturewith:(NSString*)profilePictureUrl
{
    ivProfile.image = [UIImage imageNamed:profilePictureUrl];
}

@end

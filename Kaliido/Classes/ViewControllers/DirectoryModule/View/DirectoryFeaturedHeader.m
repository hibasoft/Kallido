//
//  DirectoryFeaturedHeader.m
//  Kaliido
//
//  Created by Vadim Budnik on 6/25/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import "DirectoryFeaturedHeader.h"

@implementation DirectoryFeaturedHeader

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

- (void)configureView
{
    ivImage.clipsToBounds = YES;
    self.clipsToBounds = YES;
}

#pragma mark - Configure View

- (void)configureViewWith:(NSDictionary *)data
{
    NSString *title = [data objectForKey:@"title"];
    NSString *subtitle = [data objectForKey:@"subtitle"];
    NSString *imageURL = [data objectForKey:@"image_url"];
    
    lbTitle.text = title;
    lbSubTitle.text = subtitle;
    [ivImage setImage:[UIImage imageNamed:imageURL]];
}

@end

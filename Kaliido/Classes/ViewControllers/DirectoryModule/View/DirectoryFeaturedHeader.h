//
//  DirectoryFeaturedHeader.h
//  Kaliido
//
//  Created by Vadim Budnik on 6/25/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomView.h"

@protocol DirectoryFeaturedHeaderDelegate <NSObject>

@optional



@end

@interface DirectoryFeaturedHeader : CustomView
{
    IBOutlet UILabel *lbTitle;
    IBOutlet UILabel *lbSubTitle;
    IBOutlet UIImageView *ivImage;
}

@property (assign) id<DirectoryFeaturedHeaderDelegate> delegate;

- (void)configureViewWith:(NSDictionary*)data;

@end

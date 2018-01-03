//
//  DHFeaturedViewController.h
//  Kaliido
//
//  Created by Vadim Budnik on 6/21/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DirectoryFeaturedHeader.h"

@protocol DHFeaturedVCProtocol <NSObject>

@optional



@end

@interface DHFeaturedViewController : UIViewController
{
    IBOutlet UITableView *tbContentList;
    IBOutlet DirectoryFeaturedHeader *vwFeaturedHeader;
}

@property (assign) id<DHFeaturedVCProtocol> delegate;

@end

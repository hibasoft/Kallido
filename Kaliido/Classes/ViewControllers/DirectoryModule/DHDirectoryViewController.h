//
//  DHDirectoryViewController.h
//  Kaliido
//
//  Created by Vadim Budnik on 6/21/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryViewModel.h"
@class Category;

@protocol DHDirectoryVCProtocol <NSObject>

@optional

- (void)didSelectCategory:(CategoryViewModel*)selectedItem;

@end

@interface DHDirectoryViewController : UIViewController
{
    IBOutlet UITableView *tbContentList;
}

@property (assign) id<DHDirectoryVCProtocol> delegate;

@end

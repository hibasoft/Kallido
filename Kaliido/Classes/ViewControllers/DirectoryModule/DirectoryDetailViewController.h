//
//  DirectoryDetailViewController.h
//  Kaliido
//
//  Created by Vadim Budnik on 6/21/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DirectoryViewModel.h"
@protocol DirectoryDetailVCProtocol <NSObject>

@optional



@end

@class Directory;
@class DirectoryDetailHeader;

@interface DirectoryDetailViewController : UIViewController
{
    IBOutlet UITableView *tbContentList;
    IBOutlet DirectoryDetailHeader *vwDetailHeader;
}

@property (assign) id<DirectoryDetailVCProtocol> delegate;

@property (nonatomic, strong) DirectoryViewModel *selectedDirectory;

@end

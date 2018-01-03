//
//  DirectoryContainerViewController.h
//  Kaliido
//
//  Created by Vadim Budnik on 6/23/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CategoryViewModel.h"

@protocol DirectoryContainerDelegate <NSObject>

@optional

- (void)didSelectDirectoryCategory:(CategoryViewModel*)selectedCategory;

@end

@interface DirectoryContainerViewController : UIViewController
{
    
}

@property (strong, nonatomic) NSString *currentSegueIdentifier;
@property (assign) id<DirectoryContainerDelegate> delegate;

- (void)swapViewControllers;

@end

//
//  REActionSheet.h
//  Kaliido
//
//  Created by Daron on 11.08.14.
//  Copyright (c) 2014 Kaliido. All rights reserved.
//

#import <UIKit/UIKit.h>

@class REActionSheet;

typedef void(^REActionSheetButtonAction)();
typedef void(^REActionSheetBlock)(REActionSheet *actionSheet);

@interface REActionSheet : UIActionSheet

+ (void)presentActionSheetInView:(UIView *)view configuration:(REActionSheetBlock)configuration;
- (void)addButtonWithTitle:(NSString *)title andActionBlock:(REActionSheetButtonAction)block;
- (void)addDestructiveButtonWithTitle:(NSString *)title andActionBlock:(REActionSheetButtonAction)block;
- (void)addCancelButtonWihtTitle:(NSString *)title andActionBlock:(REActionSheetButtonAction)block;

@end

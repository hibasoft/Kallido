//
//  KLPlaceholderTextView
//  Kaliido
//
//  Created by Daron on 20.06.14.
//  Copyright (c) 2014 Kaliido. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KLPlaceholderTextView : UITextView
/**
 *  The text to be displayed when the text view is empty. The default value is `nil`.
 */
@property (copy, nonatomic) NSString *placeHolder;
/**
 *  The color of the place holder text. The default value is `[UIColor lightGrayColor]`.
 */
@property (strong, nonatomic) UIColor *placeHolderTextColor;

@end

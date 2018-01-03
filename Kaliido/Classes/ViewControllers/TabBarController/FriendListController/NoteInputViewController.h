//
//  NoteInputViewController.h
//  Kaliido
//
//  Created by  Kaliido on 12/23/15.
//  Copyright © 2015 Kaliido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KLPlaceholderTextView.h"
@interface NoteInputViewController : UIViewController
@property (strong, nonatomic) IBOutlet KLPlaceholderTextView *viewEdit;
@property (nonatomic) int userId;
@end
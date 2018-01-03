//
//  DirectoryHomeViewController.h
//  Kaliido
//
//  Created by Vadim Budnik on 6/21/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DirectoryHomeViewController : UIViewController
{
    IBOutlet UIButton *btFeatured;
    IBOutlet UIButton *btDirectory;
}

- (IBAction)didRequestToSwitchToFeatured:(id)sender;
- (IBAction)didRequestToSwitchToDirectory:(id)sender;

@end

//
//  CustomSegue.m
//  Q-municate
//
//  Created by Daron on 13/02/2014.
//  Copyright (c) 2014 Kaliido. All rights reserved.
//

#import "CustomSegue.h"
#import "AppDelegate.h"

@implementation CustomSegue

- (void)perform {
    
    AppDelegate *delegate =  (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIWindow *window = delegate.window;
    window.rootViewController = self.destinationViewController;
}

@end

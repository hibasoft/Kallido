//
//  StumblersViewModel.m
//  Kaliido
//
//  Created by Phoenix on 6/29/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import "StumblersViewModel.h"

@implementation StumblersViewModel

- (instancetype)initWithStumblers:(NSArray*)stumblerList
{
    self = [super init];
    if (!self) return nil;
    
    _arStumblers = stumblerList;
    
    return self;
}

@end

//
//  StumblerViewModel.m
//  Kaliido
//
//  Created by Vadim Budnik on 6/29/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import "StumblerViewModel.h"
#import "Stumbler.h"

@implementation StumblerViewModel

- (instancetype)initWithStumbler:(Stumbler*)stumbler
{
    self = [super init];
    if (!self) return nil;
    
    _stumblerName = stumbler.stumblerName;
    _avatarURL = stumbler.avatarURL;
    
    return self;
}

@end

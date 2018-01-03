//
//  PerksViewModel.m
//  Kaliido
//
//  Created by Vadim Budnik on 6/28/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import "PerksViewModel.h"

@implementation PerksViewModel

- (instancetype)initWithPerks:(NSArray*)perkList
{
    self = [super init];
    if (!self) return nil;
    
    _arPerks = perkList;
    
    return self;
}

@end

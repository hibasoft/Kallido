//
//  PerkViewModel.m
//  Kaliido
//
//  Created by Vadim Budnik on 6/28/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import "PerkViewModel.h"
#import "Perk.h"

@implementation PerkViewModel

- (instancetype)initWithPerk:(Perk*)perk
{
    self = [super init];
    if (!self) return nil;
    
    _perkName = perk.perkName;
    _thumbnailURL = perk.thumbnailURL;
    
    return self;
}

@end

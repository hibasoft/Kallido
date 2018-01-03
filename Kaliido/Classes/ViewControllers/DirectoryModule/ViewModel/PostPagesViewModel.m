//
//  PostPagesViewModel.m
//  Kaliido
//
//  Created by Vadim Budnik on 7/1/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import "PostPagesViewModel.h"

@implementation PostPagesViewModel

- (instancetype)initWithPostPages:(NSArray*)pageList
{
    self = [super init];
    if (!self) return nil;
    
    _arPostPages = pageList;
    
    return self;
}

@end

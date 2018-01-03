//
//  CategoriesViewModel.m
//  Kaliido
//
//  Created by Vadim Budnik on 6/28/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import "CategoriesViewModel.h"

@implementation CategoriesViewModel

- (instancetype)initWithCategories:(NSArray*)categoryList
{
    self = [super init];
    if (!self) return nil;
    
    _arCategories = categoryList;
    
    return self;
}

@end

//
//  CategoryViewModel.m
//  Kaliido
//
//  Created by Vadim Budnik on 6/23/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import "CategoryViewModel.h"

@implementation CategoryViewModel

- (instancetype)initWithDictionary:(NSDictionary*)dic
{
    self = [super init];
    if (!self) return nil;
    
    _categoryId = [[dic objectForKey:@"id"] integerValue];
    _categoryName = [dic objectForKey:@"name"];
    _categoryDescription = [dic objectForKey:@"fullDescription"];
    _imageUIDStandard = [dic objectForKey:@"imageUIDStandard"];
    _imageUIDRetina = [dic objectForKey:@"imageUIDStandard"];
    
    
    return self;
}

@end

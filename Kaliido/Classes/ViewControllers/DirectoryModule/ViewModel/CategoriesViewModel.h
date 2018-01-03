//
//  CategoriesViewModel.h
//  Kaliido
//
//  Created by Vadim Budnik on 6/28/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoriesViewModel : NSObject

@property (nonatomic, readonly) NSArray *arCategories;

- (instancetype)initWithCategories:(NSArray*)categoryList;

@end

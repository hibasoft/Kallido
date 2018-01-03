//
//  CategoryViewModel.h
//  Kaliido
//
//  Created by Vadim Budnik on 6/23/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CategoryViewModel : NSObject

@property (nonatomic, readwrite) NSInteger categoryId;
@property (nonatomic, retain) NSString *categoryName;
@property (nonatomic, retain) NSString *categoryDescription;
@property (nonatomic, retain) NSString *imageUIDStandard;
@property (nonatomic, retain) NSString *imageUIDRetina;

- (instancetype)initWithDictionary:(NSDictionary*)dic;

@end

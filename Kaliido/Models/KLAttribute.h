//
//  KLAttribute.h
//  Kaliido
//
//  Created by Hiba on 03/07/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import "KLBaseModel.h"

@interface KLAttribute : KLBaseModel

@property (nonatomic, assign) NSUInteger ID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) KLAttribute *relatedAttribute;

@end

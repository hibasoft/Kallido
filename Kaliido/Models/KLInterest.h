//
//  KLInterest.h
//  Kaliido
//
//  Created by Admin on 7/2/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import "KLBaseModel.h"
#import "KLAttribute.h"

@interface KLInterest : KLBaseModel

@property (nonatomic, assign) NSUInteger ID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) KLAttribute *relatedAttribute;
- (id)initWithData:(NSUInteger) ID name:(NSString*) name;
@end

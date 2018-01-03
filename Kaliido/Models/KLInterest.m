//
//  KLInterest.m
//  Kaliido
//
//  Created by Admin on 7/2/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import "KLInterest.h"

@implementation KLInterest


- (id)initWithData:(NSUInteger) ID name:(NSString*) name {
    
    if (self = [super init]) {
 
        self.ID = ID;
        self.name = name;
    }
    
    return self;
}
@end

//
//  KLCornerButton.m
//  Kaliido
//
//  Created by Daron on 30.06.14.
//  Copyright (c) 2014 Kaliido. All rights reserved.
//

#import "KLCornerButton.h"

@implementation KLCornerButton

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.cornerRadius = 10;
}

@end

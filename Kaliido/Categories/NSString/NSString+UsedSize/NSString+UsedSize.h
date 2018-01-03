//
//  NSString+UsedSize.h
//  Kaliido
//
//  Created by Daron on 13.06.14.
//  Copyright (c) 2014 Kaliido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (UsedSize)

- (CGSize)usedSizeForWidth:(CGFloat)width font:(UIFont *)font withAttributes:(NSDictionary *)attributes;

@end

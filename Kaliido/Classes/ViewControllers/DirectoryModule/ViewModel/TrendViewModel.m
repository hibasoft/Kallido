//
//  TrendViewModel.m
//  Kaliido
//
//  Created by Vadim Budnik on 6/26/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import "TrendViewModel.h"

@implementation TrendViewModel

- (instancetype)initWithTrend:(NSDictionary*)trend
{
    self = [super init];
    if (!self) return nil;
    
    _arTrends = [trend objectForKey:@"trends"];
    
    return self;

}

@end

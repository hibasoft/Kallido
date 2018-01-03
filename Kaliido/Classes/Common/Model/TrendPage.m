//
//  TrendPage.m
//  Kaliido
//
//  Created by Vadim Budnik on 6/28/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import "TrendPage.h"

@implementation TrendPage

- (instancetype)initWithID:(NSInteger)Id Name:(NSString*)name ProfileURL:(NSString*)profileUrl CoverURL:(NSString*)coverUrl
{
    self = [super init];
    if (!self)
        return nil;
    
    _trendPageId = Id;
    _trendPageName = name;
    _profileURL = profileUrl;
    _coverURL = coverUrl;
    
    return self;
}

@end

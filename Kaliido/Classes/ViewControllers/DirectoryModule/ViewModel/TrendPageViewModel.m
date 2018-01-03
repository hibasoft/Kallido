//
//  TrendPageViewModel.m
//  Kaliido
//
//  Created by Vadim Budnik on 6/28/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import "TrendPageViewModel.h"
#import "TrendPage.h"

@implementation TrendPageViewModel

- (instancetype)initWithTrendPage:(TrendPage*)trendPage
{
    self = [super init];
    if (!self) return nil;
    
    _trendPageTitle = trendPage.trendPageName;
    _pageProfileURL = trendPage.profileURL;
    _pageCoverURL = trendPage.coverURL;
    
    return self;
}

@end

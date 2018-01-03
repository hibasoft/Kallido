//
//  TrendPageViewModel.h
//  Kaliido
//
//  Created by Vadim Budnik on 6/28/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TrendPage;

@interface TrendPageViewModel : NSObject

@property (nonatomic, readonly) NSString *trendPageTitle;
@property (nonatomic, readonly) NSString *pageProfileURL;
@property (nonatomic, readonly) NSString *pageCoverURL;

- (instancetype)initWithTrendPage:(TrendPage*)trendPage;

@end

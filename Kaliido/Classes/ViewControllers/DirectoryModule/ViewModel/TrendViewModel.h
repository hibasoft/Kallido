//
//  TrendViewModel.h
//  Kaliido
//
//  Created by Vadim Budnik on 6/26/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrendViewModel : NSObject

@property (nonatomic, readonly) NSArray *arTrends;

- (instancetype)initWithTrend:(NSDictionary*)trend;

@end

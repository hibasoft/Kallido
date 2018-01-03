//
//  TrendPage.h
//  Kaliido
//
//  Created by Vadim Budnik on 6/28/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrendPage : NSObject

@property (nonatomic, assign) NSInteger trendPageId;
@property (nonatomic, strong) NSString *trendPageName;
@property (nonatomic, strong) NSString *coverURL;
@property (nonatomic, strong) NSString *profileURL;

- (instancetype)initWithID:(NSInteger)Id Name:(NSString*)name ProfileURL:(NSString*)profileUrl CoverURL:(NSString*)coverUrl;

@end

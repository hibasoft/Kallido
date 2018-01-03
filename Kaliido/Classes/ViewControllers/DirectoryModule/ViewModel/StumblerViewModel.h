//
//  StumblerViewModel.h
//  Kaliido
//
//  Created by Vadim Budnik on 6/29/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Stumbler;

@interface StumblerViewModel : NSObject

@property (nonatomic, readonly) NSString *stumblerName;
@property (nonatomic, readonly) NSString *avatarURL;

- (instancetype)initWithStumbler:(Stumbler*)stumbler;

@end

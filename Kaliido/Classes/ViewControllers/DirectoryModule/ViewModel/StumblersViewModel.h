//
//  StumblersViewModel.h
//  Kaliido
//
//  Created by Phoenix on 6/29/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StumblersViewModel : NSObject

@property (nonatomic, readonly) NSArray *arStumblers;

- (instancetype)initWithStumblers:(NSArray*)stumblerList;

@end

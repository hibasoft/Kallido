//
//  PerksViewModel.h
//  Kaliido
//
//  Created by Vadim Budnik on 6/28/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PerksViewModel : NSObject

@property (nonatomic, readonly) NSArray *arPerks;

- (instancetype)initWithPerks:(NSArray*)perkList;

@end

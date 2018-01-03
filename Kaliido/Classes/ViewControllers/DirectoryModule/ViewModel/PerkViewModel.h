//
//  PerkViewModel.h
//  Kaliido
//
//  Created by Vadim Budnik on 6/28/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Perk;

@interface PerkViewModel : NSObject

@property (nonatomic, readonly) NSString *perkName;
@property (nonatomic, readonly) NSString *thumbnailURL;

- (instancetype)initWithPerk:(Perk*)perk;

@end

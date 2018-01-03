//
//  Perk.h
//  Kaliido
//
//  Created by Vadim Budnik on 6/28/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Perk : NSObject

@property (nonatomic, assign) NSInteger perkId;
@property (nonatomic, strong) NSString *perkName;
@property (nonatomic, strong) NSString *thumbnailURL;

- (instancetype)initWithID:(NSInteger)Id Name:(NSString*)name Thumbnail:(NSString*)url;

@end

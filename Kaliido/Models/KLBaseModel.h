//
//  KLBaseModel.h
//  Kaliido
//
//  Created by  Kaliido on 9/24/15.
//  Copyright © 2015 Kaliido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KLBaseModel : NSObject<NSCopying>

+ (id) objectWithDictionary:(NSDictionary *)dictionary;
+ (id) objectToDictionary:(id)objectInfo;

- (NSDictionary *) toDictionary;

+ (id) itemFromDictionary:(NSDictionary*) dict
                      key:(id) memberKey
                  default:(id) defaultValue;

+ (NSArray *) arrayItemFromDictionary:(NSDictionary *) dict
                                  key:(id) memberKey
                                class:(Class) elemClass;

+ (NSDictionary *) addItemToDictionary:(NSDictionary*) dict
                                   key:(id) memberKey
                                 value:(id) value
                               default:(id) defaultValue;

@end

#pragma mark - NSArray Deep Copy

@interface NSArray (Copy)

- (id)deepCopyArray;

@end

#pragma mark - NSDictionary Deep Copy

@interface NSDictionary (Copy)

- (id)deepCopyDictionary;

@end
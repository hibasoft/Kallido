//
//  KLAutoCompleteManager.h
//  Kaliido
//
//  Created by  Kaliido on 12/24/15.
//  Copyright © 2015 Kaliido. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTAutocompleteTextField.h"

typedef enum {
    KLAutocompleteTypeInterest, // Default
    HTAutocompleteTypeName,
} KLAutocompleteType;

@interface KLAutoCompleteManager  : NSObject <HTAutocompleteDataSource>

+ (KLAutoCompleteManager *)sharedManager;
@property(strong, nonatomic) NSArray* autoCompleteArray;
@end

//
//  KLAutoCompleteManager.m
//  Kaliido
//
//  Created by  Kaliido on 12/24/15.
//  Copyright © 2015 Kaliido. All rights reserved.
//

#import "KLAutoCompleteManager.h"
static KLAutoCompleteManager *sharedManager;
@implementation KLAutoCompleteManager

+ (KLAutoCompleteManager *)sharedManager
{
    static dispatch_once_t done;
    dispatch_once(&done, ^{ sharedManager = [[KLAutoCompleteManager alloc] init]; });
    return sharedManager;
}

#pragma mark - HTAutocompleteTextFieldDelegate

- (NSString *)textField:(HTAutocompleteTextField *)textField
    completionForPrefix:(NSString *)prefix
             ignoreCase:(BOOL)ignoreCase
{
    if (textField.autocompleteType == KLAutocompleteTypeInterest)
    {
        NSString *stringToLookFor;
        NSArray *componentsString = [prefix componentsSeparatedByString:@","];
        NSString *prefixLastComponent = [componentsString.lastObject stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (ignoreCase)
        {
            stringToLookFor = [prefixLastComponent lowercaseString];
        }
        else
        {
            stringToLookFor = prefixLastComponent;
        }
        
        for (NSString *stringFromReference in self.autoCompleteArray)
        {
            NSString *stringToCompare;
            if (ignoreCase)
            {
                stringToCompare = [stringFromReference lowercaseString];
            }
            else
            {
                stringToCompare = stringFromReference;
            }
            
            if ([stringToCompare hasPrefix:stringToLookFor])
            {
                return [stringFromReference stringByReplacingCharactersInRange:[stringToCompare rangeOfString:stringToLookFor] withString:@""];
            }
            
        }
    }
    
    return @"";
}
@end

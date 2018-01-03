//
//  PostPagesViewModel.h
//  Kaliido
//
//  Created by Vadim Budnik on 7/1/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostPagesViewModel : NSObject

@property (nonatomic, readonly) NSArray *arPostPages;

- (instancetype)initWithPostPages:(NSArray*)pageList;

@end

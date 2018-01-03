//
//  KLPhoto.h
//  Kaliido
//
//  Created by Admin on 7/2/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import "KLBaseModel.h"
#import "KLUser.h"

@interface KLPhoto : KLBaseModel

@property (nonatomic, assign) NSUInteger ID;
@property (nonatomic, strong) NSString *photoUID;
@property (nonatomic, strong) NSString *Description;
@property (nonatomic, strong) NSDate *createdDate;
@property (nonatomic, strong) KLUser *uploader;

@end

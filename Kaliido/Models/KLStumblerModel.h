//
//  KLStumblerModel.h
//  Kaliido
//
//  Created by  Kaliido on 9/24/15.
//  Copyright © 2015 Kaliido. All rights reserved.
//

#import "KLBaseModel.h"

@interface KLStumblerModel : KLBaseModel
@property (nonatomic)           NSInteger       stumblerId;
@property (strong, nonatomic)   NSString*       name;
@property (strong, nonatomic)   NSString*       date;
@property (strong, nonatomic)   NSString*       imageUID;
@property (nonatomic)           NSInteger       invitedCount;

@property (strong, nonatomic)   NSString*       post;
@property (strong, nonatomic)   NSString*       privacy;
@property (strong, nonatomic)   NSString*       address;
@property (nonatomic)           NSNumber*       latitude;
@property (nonatomic)           NSNumber*       longitude;
@property (strong, nonatomic)   NSString*       createDate;
@property (nonatomic)           NSInteger       userOwnerId;
@property (strong, nonatomic)   NSString*       ownerFullname;
@property (strong, nonatomic)   NSString*       ownerUserPhotoUid;
@property (nonatomic)           NSInteger       goingCount;
@property (nonatomic)           NSInteger       maybeCount;

@property (strong, nonatomic)   NSArray*        attendees;
@property (strong, nonatomic)   NSArray*        subcategoryids;
- (NSDictionary *) toDictionary;
- (NSDictionary *) postDictionary;
@end

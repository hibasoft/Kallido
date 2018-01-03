//
//  GroupModel.h
//  Kaliido
//
//  Hiba on 1/9/17.
//  Copyright © 2017 Kaliido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupModel : NSObject
    
    @property (nonatomic, assign) NSInteger groupId;
    @property (nonatomic, strong) NSString *imgUrl;
    @property (nonatomic, strong) NSString *groupName;
    @property (nonatomic, strong) NSString *memberCount;
@end

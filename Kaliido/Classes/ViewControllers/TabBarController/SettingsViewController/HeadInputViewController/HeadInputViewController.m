//
//  HeadInputViewController.m
//  Kaliido
//
//  Created by  Kaliido on 8/31/15.
//  Copyright (c) 2015 Kaliido. All rights reserved.
//

#import "HeadInputViewController.h"

@implementation HeadInputViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.viewEdit.placeHolder = NSLocalizedString(@"KL_STR_TELLWHATSUP", nil);
    if (self.parent != nil)
    {
        if ([self.title isEqualToString:@"HeadLine"])
        {
            NSString * headline = self.parent.profileDic[@"headLine"];
            if (headline != nil && ![headline isEqual:[NSNull null]] && headline.length > 0)
                self.viewEdit.text = self.parent.profileDic[@"headLine"];
        }else
        {
            NSString * aboutme = self.parent.profileDic[@"aboutMe"];
            if (aboutme != nil && ![aboutme isEqual:[NSNull null]] && aboutme.length > 0)
                self.viewEdit.text = self.parent.profileDic[@"aboutMe"];
        }
    }else
    {
        if ([self.title isEqualToString:@"HeadLine"])
        {
            NSString * headline = self.detailParent.profileDic[@"headLine"];
            if (headline != nil && ![headline isEqual:[NSNull null]] && headline.length > 0)
                self.viewEdit.text = self.detailParent.profileDic[@"headLine"];
        }else
        {
            NSString * aboutme = self.detailParent.profileDic[@"aboutMe"];
            if (aboutme != nil && ![aboutme isEqual:[NSNull null]] && aboutme.length > 0)
                self.viewEdit.text = self.detailParent.profileDic[@"aboutMe"];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.parent != nil)
    {
        if ([self.title isEqualToString:@"HeadLine"])
        {
            [self.parent.profileDic setValue:self.viewEdit.text forKey:@"headLine"];
        }
        else
            [self.parent.profileDic setValue:self.viewEdit.text forKey:@"aboutMe"];
    }else
    {
        if ([self.title isEqualToString:@"HeadLine"])
            [self.detailParent.profileDic setValue:self.viewEdit.text forKey:@"headLine"];
        else
            [self.detailParent.profileDic setValue:self.viewEdit.text forKey:@"aboutMe"];
        
    }
}
@end

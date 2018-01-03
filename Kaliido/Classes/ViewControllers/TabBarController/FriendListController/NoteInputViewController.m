//
//  NoteInputViewController.m
//  Kaliido
//
//  Created by  Kaliido on 12/23/15.
//  Copyright © 2015 Kaliido. All rights reserved.
//

#import "NoteInputViewController.h"
#import "KLWebService.h"


@interface NoteInputViewController ()

@end

@implementation NoteInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.viewEdit.placeHolder = NSLocalizedString(@"KL_STR_TELLWHATSUP", nil);
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)BackButtonClicked:(id)sender {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [[KLWebService getInstance] updateUserNote:self.viewEdit.text UserId:self.userId withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        [SVProgressHUD dismiss];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}
@end

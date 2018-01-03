//
//  DirectoryAboutCell.m
//  Kaliido
//
//  Created by Vadim Budnik on 7/1/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import "DirectoryAboutCell.h"
#import "DirectoryViewModel.h"

@interface DirectoryAboutCell()

- (IBAction)didTapOnViewAll:(id)sender;
- (IBAction)didTapOnMakeCall:(id)sender;

@end

@implementation DirectoryAboutCell

@synthesize delegate;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self configureView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureView
{
    
}

#pragma mark - Actions

- (IBAction)didTapOnViewAll:(id)sender
{
    
}

- (IBAction)didTapOnMakeCall:(id)sender
{
    
}

#pragma mark - Configure Cell With DirectoryViewModel

- (void)configureCellWithDirectoryViewModel:(DirectoryViewModel*)directoryModel
{
    lbAddress.text = directoryModel.directoryLocation;
    
    NSString *phoneNoTitle = [NSString stringWithFormat:@"Call %@", directoryModel.directoryPhoneNo];
    [btPhoneNo setTitle:phoneNoTitle forState:UIControlStateNormal];
}

@end

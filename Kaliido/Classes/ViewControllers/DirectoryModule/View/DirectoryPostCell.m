//
//  DirectoryPostCell.m
//  Kaliido
//
//  Created by Vadim Budnik on 7/1/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import "DirectoryPostCell.h"
#import "PostPagesViewModel.h"
#import "PostPageTableCell.h"
#import "PostPage.h"
#import "PostPageViewModel.h"

static NSString *postPageTableCellIdentifier = @"PostPageTableCell";

@interface DirectoryPostCell() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) PostPagesViewModel *pagesModel;

@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat overallHeight;

- (IBAction)didTapOnViewAll:(id)sender;

@end

@implementation DirectoryPostCell

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
    _cellHeight = 90.0f;
    
    [tbPostPageList registerNib:[UINib nibWithNibName:postPageTableCellIdentifier bundle:nil] forCellReuseIdentifier:postPageTableCellIdentifier];
    tbPostPageList.clipsToBounds = YES;
    tbPostPageList.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    btViewAll.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
    
    btViewAll.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    btViewAll.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    btViewAll.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
}

#pragma mark - Actions

- (IBAction)didTapOnViewAll:(id)sender
{
    if ([(id)delegate respondsToSelector:@selector(didRequestToViewAllPostPages)])
    {
        [delegate didRequestToViewAllPostPages];
    }
}

#pragma mark - Configure Cell With PostPagesViewModel

- (void)configureCellWithPostPagesViewModel:(PostPagesViewModel*)postPageModel
{
    self.pagesModel = postPageModel;
    
    if ([_pagesModel.arPostPages count] == 0)
    {
        _overallHeight = 90.0f;
        vwNoResult.hidden = NO;
        vwPosts.hidden = YES;
    }
    else
    {
        if ([_pagesModel.arPostPages count]>3)
        {
            _overallHeight = _cellHeight * 3;
        }
        else
        {
            _overallHeight = _cellHeight * [_pagesModel.arPostPages count];
        }
        vwNoResult.hidden = YES;
        vwPosts.hidden = NO;
    }
    
    constraintPostViewHeight.constant = _overallHeight;
    constraintNoPostViewHeight.constant = _overallHeight;
    [self layoutIfNeeded];
    
    [tbPostPageList reloadData];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.pagesModel.arPostPages count]>3)
    {
        return 3;
    }
    
    return [self.pagesModel.arPostPages count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PostPageTableCell *cell = [tableView dequeueReusableCellWithIdentifier:postPageTableCellIdentifier];
    
    PostPage *item = [self.pagesModel.arPostPages objectAtIndex:indexPath.row];
    PostPageViewModel *itemVM = [[PostPageViewModel alloc] initWithPostPage:item];
    [cell configureCellWithPostPageViewModel:itemVM];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([(id)delegate respondsToSelector:@selector(didSelectPostPageItemAtIndex:)])
    {
        [delegate didSelectPostPageItemAtIndex:indexPath.row];
    }
}

@end

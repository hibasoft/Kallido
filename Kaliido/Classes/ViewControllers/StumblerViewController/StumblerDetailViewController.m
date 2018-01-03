//
//  StumblerDetailViewController.m
//  Kaliido
//
//  Created by  Kaliido on 2/24/15.
//  Copyright (c) 2015 Kaliido. All rights reserved.
//

#import "StumblerDetailViewController.h"
#import "KLImageView.h"
#import "AttendeTableViewCell.h"

@interface StumblerDetailViewController ()
@property (strong, nonatomic) IBOutlet KLImageView *imgProfile;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UILabel *lblNumAttendees;
@property (strong, nonatomic) IBOutlet UILabel *lblGoingCount;
@property (strong, nonatomic) IBOutlet UILabel *lblMaybeCount;
@property (strong, nonatomic) IBOutlet UILabel *lblInvirCount;

@end

@implementation StumblerDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lblName.text = self.model.name;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
    NSDate *myDate = [df dateFromString:self.model.date];
    [df setDateFormat:@"EEEE hh a"];
    
    self.lblDate.text = [df stringFromDate:myDate];
//    self.lblDate.text = self.model.date;
    self.lblNumAttendees.text = [NSString stringWithFormat:@"%ld attendees",self.model.attendees.count];
    self.lblGoingCount.text = [NSString stringWithFormat:@"%ld",self.model.goingCount];
    self.lblMaybeCount.text = [NSString stringWithFormat:@"%ld",self.model.maybeCount];
    self.lblInvirCount.text = [NSString stringWithFormat:@"%ld", self.model.invitedCount];
    
    UIImage *placeholder = [UIImage imageNamed:@"sbackground"];
    
    NSURL *url = [NSURL URLWithString:self.model.imageUID];//[UsersUtils userAvatarURL:self.currentUser];
    
    [self.imgProfile setImageWithURL:url
                         placeholder:placeholder
                             options:SDWebImageHighPriority
                            progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                NSLog(@"r - %ld; e - %ld", receivedSize, expectedSize);
                            } completedBlock:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                
                            }];
    self.imgProfile.layer.masksToBounds = NO;
    self.imgProfile.layer.borderWidth = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (IBAction) actionBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.model.attendees.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AttendeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AttendeeCell"];
    NSDictionary *attendeeDic = [self.model.attendees objectAtIndex:indexPath.row];
    cell.attendeeNameLabel.text = [attendeeDic valueForKey:@"fullName"];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [attendeeDic valueForKey:@"date"];
    if (dateString != nil && dateString.length > 0)
        dateString = [dateString substringToIndex:10];
    NSDate *myDate = [df dateFromString:dateString];
    [df setDateFormat:@"dd MMM yyyy"];

    cell.attendeeDateLabel.text = [df stringFromDate:myDate];
    UIImage *placeholder = [UIImage imageNamed:@"upic-placeholder"];
    NSURL *url = nil;
    if(![[attendeeDic valueForKey:@"photoUID"] isEqual:[NSNull null]])
        url = [NSURL URLWithString:[attendeeDic valueForKey:@"photoUID"]];//[UsersUtils userAvatarURL:self.currentUser];
    
    [cell.attendeeImageView setImageWithURL:url
                         placeholder:placeholder
                             options:SDWebImageHighPriority
                            progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                NSLog(@"r - %ld; e - %ld", receivedSize, expectedSize);
                            } completedBlock:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                
                            }];
    return cell;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}
@end

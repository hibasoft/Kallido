//
//  DiscoverViewController.m
//  Kaliido
//
//  Hiba on 1/8/17.
//  Copyright © 2017 Kaliido. All rights reserved.
//

#import "DiscoverViewController.h"

#import "ActivityViewController.h"



@interface DiscoverViewController ()

@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    mWeather = [[WeatherModel alloc] init];
    mNotification = [[NotificationModel alloc] init];
    mArrayActivity = [NSMutableArray arrayWithCapacity:3];
    mArrayEvent = [NSMutableArray array];
    mArrayGroup = [NSMutableArray array];
    
    
    ActivityModel* tmpActivity1 = [[ActivityModel alloc] init];
    tmpActivity1.activityPercent = 50;
    tmpActivity1.activityType = 0;
    [mArrayActivity addObject: tmpActivity1];
    
    ActivityModel* tmpActivity2 = [[ActivityModel alloc] init];
    tmpActivity2.activityPercent = 30;
    tmpActivity2.activityType = 1;
    [mArrayActivity addObject: tmpActivity2];
    
    ActivityModel* tmpActivity3 = [[ActivityModel alloc] init];
    tmpActivity3.activityPercent = 20;
    tmpActivity3.activityType = 2;
    [mArrayActivity addObject: tmpActivity3];
    
    mWeather.greatingMessage = @"Have a nice Weekend,";
    mWeather.cityName = @"SYDNEY";
    mWeather.temperature = @"25";
    
    mNotification.firstMessage = @"X-mas is coming to the town,";
    mNotification.secondMessage = @"Enjoy the holidays with your beloveds!";
    
    EventModel* tmpEvent1 = [[EventModel alloc]init];
    tmpEvent1.eventId = 0;
    tmpEvent1.eventName = @"Seminar: UX in the professional world";
    tmpEvent1.eventDate = @"27 December, 2016";
    [mArrayEvent addObject:tmpEvent1];
    
    EventModel* tmpEvent2 = [[EventModel alloc]init];
    tmpEvent2.eventId = 0;
    tmpEvent2.eventName = @"Grand opening H&M Hanoi";
    tmpEvent2.eventDate = @"15 December, 2016";
    [mArrayEvent addObject:tmpEvent2];
    
    
    GroupModel* tmpGroup1 = [[GroupModel alloc]init];
    tmpGroup1.groupId = 0;
    tmpGroup1.groupName = @"Oil painting lovers";
    tmpGroup1.memberCount = @"270 members";
    [mArrayGroup addObject:tmpGroup1];
    
    GroupModel* tmpGroup2 = [[GroupModel alloc]init];
    tmpGroup2.groupId = 0;
    tmpGroup2.groupName = @"Arsenal Supporters’ Trust";
    tmpGroup2.memberCount = @"234 members";
    [mArrayGroup addObject:tmpGroup2];
    
    
    [self.tableView reloadData];
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:

        if (bCloseNotification) {
            return 1;
        }
            return 2;
            break;
        case 1:
            return 3;
            break;
        case 2:
            return 2;
            break;
        case 3:
            return 2;
            break;
            
        default:
            break;
    }
    return 0;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    WeatherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"weather"];
                    cell.greatingLabel.text = mWeather.greatingMessage;
                    cell.cityLabel.text = mWeather.cityName;
                    cell.tempratureLabel.text = mWeather.temperature;
                    return cell;
                    break;
                }
                case 1:{
                    NotificationTableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"notification"];
                    cell.firstLabel.text = mNotification.firstMessage;
                    cell.secondLabel.text = mNotification.secondMessage;
                    cell.delegate = self;
                    return cell;
                }
                    break;
                    
            }
        }
            
        case 1:
        {
            ActivityTableViewCell* cell =[tableView dequeueReusableCellWithIdentifier:@"activity"];
            switch (indexPath.row) {
                case 0:
                {
                    cell.barView.backgroundColor = KLLIGHTBLUE;
                    cell.activityLabel.text = @"WORK";
                    cell.activityLabel.textColor = KLLIGHTBLUE;
                    cell.percentLabel.textColor = KLLIGHTBLUE;
                break;
                }
                case 1:
                {
                    cell.barView.backgroundColor = KLLIGHTPURPLE;
                    cell.activityLabel.text = @"LIFE";
                    cell.activityLabel.textColor = KLLIGHTPURPLE;
                    cell.percentLabel.textColor = KLLIGHTPURPLE;
                    break;
                }
                case 2:
                {
                    cell.barView.backgroundColor = KLLIGHTGREEN;
                    cell.activityLabel.text = @"PLAY";
                    cell.activityLabel.textColor = KLLIGHTGREEN;
                    cell.percentLabel.textColor = KLLIGHTGREEN;
                    break;
                }
                default:
                break;
            }
            
            ActivityModel* tmp = [mArrayActivity objectAtIndex:indexPath.row];
            cell.percentLabel.text = [NSString stringWithFormat:@"%d", tmp.activityPercent];
            return cell;
            break;
        }
            
        case 2:
        {
            switch (indexPath.row) {
                case 0:
                {
                    EventTableViewCell* cell =[tableView dequeueReusableCellWithIdentifier:@"event"];
                    [cell setEventData:mArrayEvent];
                    return cell;
                    break;
                }
                    
                case 1:
                {
                    UITableViewCell* cell =[tableView dequeueReusableCellWithIdentifier:@"eventlist"];
                    
                    return cell;
                    break;
                }
                    
            }
        }
            
            break;
        case 3:
        {
            switch (indexPath.row) {
                case 0:
                {
                    GroupTableViewCell* cell =[tableView dequeueReusableCellWithIdentifier:@"group"];
                    [cell setGroupData:mArrayGroup];
                    return cell;
                    break;
                }
                    
                case 1:
                {
                    UITableViewCell* cell =[tableView dequeueReusableCellWithIdentifier:@"grouplist"];
                    
                    return cell;
                    break;
                }
                    
            }
        }
            
           
            
            
    }
    return nil;
    
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                    return 70;
                    break;
                case 1:
                    return 70;
                
            }
        }
            break;
        case 1:
            return 80;
            
            break;
        case 2:
        {
            switch (indexPath.row) {
                case 0:
                    return 215;
                    break;
                case 1:
                    return 48;
                    
            }
        }
            
            break;
        case 3:
        {
            switch (indexPath.row) {
                case 0:
                    return 190;
                    break;
                case 1:
                    return 48;
                    
            }
        }
            
            break;
            
        default:
            break;
    }
    return 0;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActivityViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ActivityViewController"];
    
    [self.navigationController pushViewController:controller animated:YES];
}

    
    
-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    return 1.0;
    return 19.0;
}
    
-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0;
}
    
-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
}
    
-(UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
}
    
#pragma Notification Delegate
-(void) didCloseNotification{

    bCloseNotification = true;
    
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
    
}

@end

//
//  ActivityViewController.m
//  Kaliido
//
//  Learco on 1/9/17.
//  Copyright © 2017 Kaliido. All rights reserved.
//

#import "ActivityViewController.h"
#import "EventTableViewCell.h"
#import "GroupTableViewCell.h"
#import "HeaderTableViewCell.h"
#import "SubActivityTableViewCell.h"
#import "ActivityPeopleTableViewCell.h"

@interface ActivityViewController ()

@end

@implementation ActivityViewController
    
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
    
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
        return 5;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        
        return 1;
        break;
        case 1:
        return 8;//subactivity count
        break;
        case 2:
        return 2;
        break;
        case 3:
        return 2;
        break;
        case 4:
        return 2;
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
            HeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"header"];
            return cell;
            
        }
        
        case 1:
        {
            SubActivityTableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"subactivity"];
            return cell;
        }
        case 2:
        {
            switch (indexPath.row) {
                case 0:
                {
                    
                    ActivityPeopleTableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"activitypeople"];
                    return cell;
                }
                
                case 1:
                {
                    UITableViewCell* cell =[tableView dequeueReusableCellWithIdentifier:@"peoplelist"];
                    return cell;
                    break;
                }
                
            }
        }
        case 3:
        {
            switch (indexPath.row) {
                case 0:
                {
                    EventTableViewCell* cell =[tableView dequeueReusableCellWithIdentifier:@"event"];
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
        case 4:
        {
            switch (indexPath.row) {
                case 0:
                {
                    GroupTableViewCell* cell =[tableView dequeueReusableCellWithIdentifier:@"group"];
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
            
            return 70;
            
        }
        break;
        case 1:
        return 50;
        
        break;
        case 2:
        {
            switch (indexPath.row) {
                case 0:
                return 148;
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
                return 215;
                break;
                case 1:
                return 48;
                
            }
        }

        case 4:
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

@end

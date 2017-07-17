//
//  ActivitiesListViewController.m
//  SSA
//
//  Created by Sunera on 5/1/17.
//  Copyright © 2017 surya. All rights reserved.
//

#import "ActivitiesListViewController.h"
#import "ProgressHUD.h"
#import "ServiceModel.h"
#import "Parse.h"
#import "AlertMessage.h"
#import "AppDelegate.h"
#import "ActivitieyWebViewController.h"

@interface ActivitiesListViewController ()<UITableViewDelegate>
{
    NSMutableArray *arrayForBool;
    NSArray *kidsArray;
}
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@end

@implementation ActivitiesListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Activities";
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    arrayForBool=[[NSMutableArray alloc]init];
    [self.tableView registerNib:[UINib nibWithNibName:@"ActivitySectionHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"ActivitySectionHeaderView"];
    
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;

}

- (void)viewWillAppear:(BOOL)animated{
    [self fetchKidsActivitiesList];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 * Fetching schools list added by parent
 */
- (void)fetchKidsActivitiesList{
    
    
    [[ProgressHUD sharedProgressHUD] showActivityIndicatorOnView:self.view];
    [ServiceModel makeGetRequestFor:GetActivitiesList WithInputParams:[NSString stringWithFormat:@"userRef=%@&requestedOn=%@&requestedFrom=%@&guid=%@&geoLocation=%@",[[NSUserDefaults standardUserDefaults] objectForKey:UserRef],[appDelegate getStringFromDate:[NSDate date] withFormat:@"dd-MM-yyyy%20hh:mm:ss"],@"Mobile",[appDelegate getUUID], [appDelegate currentLocation]]  AndToken:[[NSUserDefaults standardUserDefaults] objectForKey:AccessToken] MakeHttpRequest:^(NSDictionary *response, NSError *error){
        dispatch_async(dispatch_get_main_queue(), ^{
            [[ProgressHUD sharedProgressHUD] removeHUD];
            if (!error) {
                kidsArray = [[Parse sharedParse] parseKidsActivities:[response objectForKey:@"body"]];
                for (int i=0; i<[kidsArray count]; i++) {
                    [arrayForBool addObject:[NSNumber numberWithBool:NO]];
                }
                [self.tableView reloadData];
                
            }else{
                if ([error.localizedDescription isEqualToString:TokenExpiredString]) {
                    [[AlertMessage sharedAlert] showAlertWithMessage:@"Session expired. Please login once again." withDelegate:self onViewController:self];
                }else{
                    [[AlertMessage sharedAlert] showAlertWithMessage:error.localizedDescription withDelegate:nil onViewController:self];
                }
                NSLog(@" Error : %@", error.localizedDescription);
            }
            
        });
    }];
}

#pragma -mark UITableView Delegate and Datasource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if ([[arrayForBool objectAtIndex:section] boolValue]) {
        KID_MODEL *kid = [kidsArray objectAtIndex:section];
        return [kid.activities count];
    }
    else
        return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KID_MODEL *kid = [kidsArray objectAtIndex:indexPath.section];
    KidActivitiesModel *activity = [kid.activities objectAtIndex:indexPath.row];
    
    ActivitiesListTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ActivityCell"];
    [cell.activityLabel setText:activity.templatename];
    [cell.activityDescriptionLabel setText:activity.activitysubject];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [kidsArray count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    /*************** Close the section, once the data is selected ***********************************/
    [arrayForBool replaceObjectAtIndex:indexPath.section withObject:[NSNumber numberWithBool:NO]];
    
    KID_MODEL *kid = [kidsArray objectAtIndex:indexPath.section];
    KidActivitiesModel *activity = [kid.activities objectAtIndex:indexPath.row];
    NSString *token = [NSString stringWithFormat:@"Bearer %@",[[NSUserDefaults standardUserDefaults] objectForKey:AccessToken]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSString *urlString = [NSString stringWithFormat:@"http://49.207.0.196:8888/kidactivity1.html?SchoolUniqueId=%@&userRef=%@&tid=%@&token=%@&kiduserID=%@&activityID=%@",activity.SchoolUniqueId,activity.teacheruserref,activity.templateID,token,kid.kidId,activity.activityID];
    // Form url to load
    ActivitieyWebViewController *activitieyWebViewController = [[ActivitieyWebViewController alloc] init];
    [activitieyWebViewController setUrlToLoad:urlString];
    [self.navigationController pushViewController:activitieyWebViewController animated:YES];
    
    //[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
    
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ActivitySectionHeaderView *sectionHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ActivitySectionHeaderView"];
    sectionHeaderView.tag = section;
    KID_MODEL *kid = [kidsArray objectAtIndex:section];
    [sectionHeaderView.kidNameLabel setText:kid.firstName];
    [sectionHeaderView.unreadMessagesCountLabel setHidden:true];
    [sectionHeaderView.schoolNameLabel setHidden:true];
    /********** Add UITapGestureRecognizer to SectionView   **************/
    
    UITapGestureRecognizer  *headerTapped   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderTapped:)];
    [sectionHeaderView addGestureRecognizer:headerTapped];
    
    return  sectionHeaderView;
    
    
}
- (void)sectionHeaderTapped:(UITapGestureRecognizer *)gestureRecognizer{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:gestureRecognizer.view.tag];
    if (indexPath.row == 0) {
        BOOL collapsed  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
        for (int i=0; i<[kidsArray count]; i++) {
            if (indexPath.section==i) {
                [arrayForBool replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:!collapsed]];
            }
        }
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:gestureRecognizer.view.tag] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
}
@end

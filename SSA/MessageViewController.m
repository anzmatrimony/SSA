//
//  MessageViewController.m
//  SSA
//
//  Created by Sunera on 4/30/17.
//  Copyright © 2017 surya. All rights reserved.
//

#import "MessageViewController.h"
#import "ProgressHUD.h"
#import "ServiceModel.h"
#import "AppDelegate.h"
#import "Parse.h"
#import "AlertMessage.h"
#import "SharedManager.h"
#import "ObjectManager.h"
#import "ChatViewController.h"
#import "Firebase.h"

@interface MessageViewController ()<AlertMessageDelegateProtocol>
{
    NSMutableArray *arrayForBool;
    NSArray *kidsArray;
    FIRDatabaseReference *kidRef;
    FIRDatabaseReference *messagesRef;
}
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    appDelegate = [[UIApplication sharedApplication] delegate];
    [self.tableView registerNib:[UINib nibWithNibName:@"ActivitySectionHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"ActivitySectionHeaderView"];
    
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    kidRef = [[[FIRDatabase database] reference] child:@"Kids"];
    arrayForBool=[[NSMutableArray alloc]init];
    kidsArray = [[NSArray alloc] init];
    
    [self fetchKidsList];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [messagesRef removeAllObservers];
    [kidRef removeAllObservers];
}
/**
 * Fetching schools list added by parent
 */
- (void)fetchKidsList{
    [[ProgressHUD sharedProgressHUD] showActivityIndicatorOnView:self.view];
    [ServiceModel makeGetRequestFor:KidsList WithInputParams:[NSString stringWithFormat:@"parentUserRef=%@&userRef=%@&requestedon=%@&requestedfrom=%@&guid=%@&geolocation=%@",[[NSUserDefaults standardUserDefaults] objectForKey:UserRef],[[NSUserDefaults standardUserDefaults] objectForKey:UserRef],[appDelegate getStringFromDate:[NSDate date] withFormat:@"dd-MM-yyyy%20HH:MM:SS"],@"Mobile",[appDelegate getUUID],[appDelegate currentLocation]] AndToken:[[NSUserDefaults standardUserDefaults] objectForKey:AccessToken] MakeHttpRequest:^(NSDictionary *response, NSError *error){
        dispatch_async(dispatch_get_main_queue(), ^{
            [[ProgressHUD sharedProgressHUD] removeHUD];
            if (!error) {
                NSLog(@" Response  : %@", response);
                kidsArray = (NSMutableArray *)[[Parse sharedParse] parseKidsListResponse:[response objectForKey:@"body"]];
                if (kidsArray.count > 0) {
                    for (int i=0; i<[kidsArray count]; i++) {
                        [arrayForBool addObject:[NSNumber numberWithBool:NO]];
                    }
                    [self.tableView reloadData];
                }
                [self addKidsInFirebaseIfNotAdded];
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

- (void)addKidsInFirebaseIfNotAdded{
    
    FIRDatabaseReference *ref = [[FIRDatabase database] reference];
    int i = 0;
    for (KID_MODEL *kid in kidsArray) {
        [[ref child:@"Kids"] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapShot){
            if (![snapShot hasChild:kid.kidId]) {
                FIRDatabaseReference *newKidRef;
                newKidRef = [kidRef child:kid.kidId];
                [newKidRef setValue:@{@"kidId":kid.kidId, @"kidName":kid.firstName, @"schoolUniqueId":kid.SchoolUniqueId, @"parentId":kid.parentUserRef,@"messages":@""}];
            }else{
                FIRDatabaseReference *existingKidRef;
                existingKidRef = [kidRef child:kid.kidId];
                messagesRef = [existingKidRef child:@"messages"];
                [[[messagesRef queryOrderedByChild:@"status"] queryEqualToValue:@"sent"] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapShot1){
                    NSLog(@"sent messages : %@",snapShot1.value);
                    if (snapShot1.value != nil && ![snapShot1.value isEqual:[NSNull null]]) {
                        NSDictionary *mesgDict = snapShot1.value;
                        NSMutableArray *messagesArray = [[NSMutableArray alloc] init];
                        for (NSString *key in [mesgDict allKeys]) {
                            [messagesArray addObject:[mesgDict objectForKey:key]];
                        }
                        
                        NSArray *tempArray = [messagesArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"senderId != %@",kid.kidId]];
                        kid.unreadMessagesCount = [NSString stringWithFormat:@"%lu",(unsigned long)tempArray.count];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.tableView beginUpdates];
                            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:i] withRowAnimation:UITableViewRowAnimationNone];
                            [self.tableView endUpdates];
                            
                        });
                    }
                }];
            }
        }];
        i = i + 1;
    }
}


#pragma -mark UITableView Delegate and Datasource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if ([[arrayForBool objectAtIndex:section] boolValue]) {
        return section+2;
    }
    else
        return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessagesListTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MessagesListTableViewCell"];
    [cell.messageFromLabel setText:@"Class teacher"];
    [cell.messageDescriptionLabel setText:@"message description comes here. message description comes here. message description comes here. message description comes here. message description comes here. message description comes here. message description comes here."];
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
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
    
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
    [sectionHeaderView.kidNameLabel setText:[NSString stringWithFormat:@"%@ %@",kid.firstName,kid.lastName]];
    [sectionHeaderView.schoolNameLabel setText:kid.schoolName];
    if ([kid.unreadMessagesCount integerValue] > 0) {
        sectionHeaderView.unreadMessagesCountLabel.hidden = false;
        sectionHeaderView.unreadMessagesCountLabel.text = kid.unreadMessagesCount
        ;
    }else{
        sectionHeaderView.unreadMessagesCountLabel.hidden = true;
    }
    /********** Add UITapGestureRecognizer to SectionView   **************/
    
    UITapGestureRecognizer  *headerTapped   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderTapped:)];
    [sectionHeaderView addGestureRecognizer:headerTapped];
    
    return  sectionHeaderView;
    
    
}
- (void)sectionHeaderTapped:(UITapGestureRecognizer *)gestureRecognizer{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:gestureRecognizer.view.tag];
    
    KID_MODEL *kid = [kidsArray objectAtIndex:indexPath.section];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    ChatViewController *viewController = (ChatViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"ChatViewController"];
    viewController.senderId = kid.kidId;
    viewController.kidId = kid.kidId;
    viewController.senderDisplayName = [NSString stringWithFormat:@"%@ %@",kid.firstName,kid.lastName];
    [viewController setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:viewController animated:YES];
    /*if (indexPath.row == 0) {
        BOOL collapsed  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
        for (int i=0; i<[kidsArray count]; i++) {
            if (indexPath.section==i) {
                [arrayForBool replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:!collapsed]];
            }
        }
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:gestureRecognizer.view.tag] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }*/
}

#pragma mark AlertMessageDelegateProtocol methods
- (void)clickedOkButton{
    [[SharedManager sharedManager] logoutTheUser];
    [[SharedManager sharedManager] showLoginScreen];
}
@end

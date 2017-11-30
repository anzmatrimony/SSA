//
//  KidsListViewController.m
//  SSA
//
//  Created by Sunera on 5/1/17.
//  Copyright © 2017 surya. All rights reserved.
//

#import "KidsListViewController.h"
#import "ObjectManager.h"
#import "Constants.h"
#import "ProgressHUD.h"
#import "ServiceModel.h"
#import "Parse.h"
#import "AppDelegate.h"
#import "AlertMessage.h"
#import "SharedManager.h"
#import "ChatViewController.h"
#import "Firebase.h"
#import "AddKidViewController.h"
#import "KidsListTableViewCellForTeacherTableViewCell.h"

@interface KidsListViewController ()<AlertMessageDelegateProtocol,AddKidViewControllerProtocol>{
    FIRDatabaseReference *kidRef;
}

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIImageView *kidsListImageView;

-(IBAction)addNewKidAction:(id)sender;

@end

@implementation KidsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    kidRef = [[[FIRDatabase database] reference] child:@"Kids"];
    appDelegate = [[UIApplication sharedApplication] delegate];
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    [_kidsListImageView.layer setCornerRadius:20];
    [_kidsListImageView.layer setMasksToBounds:true];
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:Role] isEqualToString:@"CT"] || [[[NSUserDefaults standardUserDefaults] objectForKey:Role] isEqualToString:@"SU"]){
        [_addKidBackgroundView setHidden:true];
        _addKidBackgroundViewHeight.constant = 0;
        [self addLogOutButton];
        [self fetchKids];
    }
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *@discussion display logout button on top right of the navigationbar
 */
- (void)addLogOutButton{
    UIBarButtonItem *logoutButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logout:)];
    /*UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
     style:UIBarButtonItemStylePlain target:self action:@selector(logout:)];*/
    
    self.navigationItem.rightBarButtonItem = logoutButtonItem;
}

- (IBAction)logout:(id)sender{
    [[SharedManager sharedManager] logoutTheUser];
    [[SharedManager sharedManager] showLoginScreen];
}

/**
 *@discussion fetching kids list for the logged in teacher / school user
 */
- (void)fetchKids{
    [[ProgressHUD sharedProgressHUD] showActivityIndicatorOnView:self.view];
    [ServiceModel makeGetRequestFor:KidListForTeacher WithInputParams:[NSString stringWithFormat:@"userRef=%@&requestedOn=%@&requestedFrom=%@&geoLocation=%@",[[NSUserDefaults standardUserDefaults] objectForKey:UserRef],[appDelegate getStringFromDate:[NSDate date] withFormat:@"dd-MM-yyyy%20HH:MM:SS"],@"Mobile",[appDelegate currentLocation]] AndToken:[[NSUserDefaults standardUserDefaults] objectForKey:AccessToken] MakeHttpRequest:^(NSDictionary *response, NSError *error){
        dispatch_async(dispatch_get_main_queue(), ^{
            [[ProgressHUD sharedProgressHUD] removeHUD];
            if (!error) {
                NSLog(@" Response  : %@", response);
                _kidsArray = (NSMutableArray *)[[Parse sharedParse] parseKidsListResponseForTeacherLogIn:[response objectForKey:@"body"]];
                [self addKidsInFirebaseIfNotAdded];
                [self updateKidsList];
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
    for (KID_MODEL *kid in _kidsArray) {
        [[ref child:@"Kids"] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapShot){
            if (![snapShot hasChild:kid.kidId]) {
                FIRDatabaseReference *newKidRef;
                newKidRef = [kidRef child:kid.kidId];
                [newKidRef setValue:@{@"kidId":kid.kidId, @"kidName":kid.firstName, @"schoolUniqueId":[[NSUserDefaults standardUserDefaults] objectForKey:schoolUniqueId], @"parentId":@"",@"messages":@""}];
            }else{
                FIRDatabaseReference *existingKidRef;
                existingKidRef = [kidRef child:kid.kidId];
                FIRDatabaseReference *messagesRef = [existingKidRef child:@"messages"];
                [[[messagesRef queryOrderedByChild:@"status"] queryEqualToValue:@"sent"] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapShot1){
                    NSLog(@"sent messages : %@",snapShot1.value);
                    if (snapShot1.value != nil && ![snapShot1.value isEqual:[NSNull null]]) {
                        NSDictionary *mesgDict = snapShot1.value;
                        NSMutableArray *messagesArray = [[NSMutableArray alloc] init];
                        for (NSString *key in [mesgDict allKeys]) {
                            [messagesArray addObject:[mesgDict objectForKey:key]];
                        }
                        
                        NSArray *tempArray = [messagesArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"senderId == %@",kid.kidId]];
                        kid.unreadMessagesCount = [NSString stringWithFormat:@"%lu",(unsigned long)tempArray.count];
                        NSLog(@" Un read messages count : %lu", tempArray.count);
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
//                            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
//                            NSArray *indexPaths = [[NSArray alloc] initWithObjects:indexPath, nil];
//                            [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
                            [self.tableView reloadData];
                        });
                    }
                }];
            }
        }];
        i = i + 1;
    }
}


- (void)updateKidsList{
    [self.tableView reloadData];
}
-(IBAction)addNewKidAction:(id)sender{
    if (self.isFromSchool) {
        AddKidViewController *addKidViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddKidViewController"];
        [addKidViewController setFromSchoolPage:true];
        [addKidViewController setFromKidsListPage:false];
        [addKidViewController setSelectedSchool:self.selectedSchool];
        [addKidViewController setAddKidViewControllerDelegate:self];
        [self.navigationController pushViewController:addKidViewController animated:YES];
    }
    if([self.kidsListViewControllerDelegate respondsToSelector:@selector(addNewKid)]){
        [self.kidsListViewControllerDelegate addNewKid];
    }
}
#pragma -mark UITableView Datasource and Delegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.kidsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:Role] isEqualToString:@"CT"] || [[[NSUserDefaults standardUserDefaults] objectForKey:Role] isEqualToString:@"SU"]){
        KidsListTableViewCellForTeacherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KidsListTableViewCellForTeacherTableViewCell"];
        KID_MODEL *kid = [_kidsArray objectAtIndex:indexPath.row];
        [cell updateCellWithData:kid];
        return cell;
    }else{
        KidsListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KidsListTableViewCell"];
        KID_MODEL *kid = [_kidsArray objectAtIndex:indexPath.row];
        [cell updateCellWithData:kid];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if([[[NSUserDefaults standardUserDefaults] objectForKey:Role] isEqualToString:@"PARENT"] || [[[NSUserDefaults standardUserDefaults] objectForKey:Role] isEqualToString:@"parent"] || self.isFromSchool){
            KID_MODEL *kid = [_kidsArray objectAtIndex:indexPath.row];
            if ([self.kidsListViewControllerDelegate respondsToSelector:@selector(didDeleteKid:)]) {
                [self.kidsListViewControllerDelegate didDeleteKid:kid];
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:Role] isEqualToString:@"CT"] || [[[NSUserDefaults standardUserDefaults] objectForKey:Role] isEqualToString:@"SU"]){    
        KID_MODEL *kid = [_kidsArray objectAtIndex:indexPath.row];
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        ChatViewController *viewController = (ChatViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"ChatViewController"];
        viewController.senderId = [[NSUserDefaults standardUserDefaults] objectForKey:schoolUniqueId];
        viewController.kidId = kid.kidId;
        viewController.senderDisplayName = [[NSUserDefaults standardUserDefaults] objectForKey:TeacherName];
        [viewController setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:viewController animated:YES];
        
    }
}

#pragma mark AlertMessageDelegateProtocol methods
- (void)clickedOkButton{
    [[SharedManager sharedManager] logoutTheUser];
    [[SharedManager sharedManager] showLoginScreen];
}

@end

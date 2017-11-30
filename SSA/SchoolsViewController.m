//
//  SchoolsViewController.m
//  SSA
//
//  Created by Sunera on 4/30/17.
//  Copyright © 2017 surya. All rights reserved.
//

#import "SchoolsViewController.h"
#import "Constants.h"
#import "ProgressHUD.h"
#import "ServiceModel.h"
#import "Parse.h"
#import "AppDelegate.h"
#import "AlertMessage.h"
#import "SharedManager.h"
#import "KidsListViewController.h"

@interface SchoolsViewController ()<AlertMessageDelegateProtocol,KidsListViewControllerProtocol>
{
    NSMutableArray *schoolsArray;
    SchoolsListViewController *schoolsListViewController;
    AddSchoolViewController *addSchoolViewController;
    UIStoryboard *storyboard;
}
@property (nonatomic, weak) IBOutlet UIView *containerView;

@end

@implementation SchoolsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    schoolsArray = [[NSMutableArray alloc] init];
    //[schoolsArray addObject:@"school"];
    
    [self fetchSchoolsList];
    
    NSString * storyboardName = @"Main";
    storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    
    [self chooseContentView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)chooseContentView{
    if (schoolsArray.count > 0) {
        [self showSchoolsListView];
    }else{
        [self showAddSchoolView];
    }
}

/**
 * Fetching schools list added by parent
 */
- (void)fetchSchoolsList{
    [[ProgressHUD sharedProgressHUD] showActivityIndicatorOnView:self.view];
    [ServiceModel makeGetRequestFor:SchoolsList WithInputParams:[NSString stringWithFormat:@"userRef=%@&requestedon=%@&requestedfrom=%@&guid=%@&parentUserRef=%@&geolocation=%@",[[NSUserDefaults standardUserDefaults] objectForKey:UserRef],[appDelegate getStringFromDate:[NSDate date] withFormat:@"dd-MM-yyyy%20hh:mm:ss"],@"Mobile",[appDelegate getUUID],[[NSUserDefaults standardUserDefaults] objectForKey:UserRef], [appDelegate currentLocation]]  AndToken:[[NSUserDefaults standardUserDefaults] objectForKey:AccessToken] MakeHttpRequest:^(NSDictionary *response, NSError *error){
        dispatch_async(dispatch_get_main_queue(), ^{
            [[ProgressHUD sharedProgressHUD] removeHUD];
            if (!error) {
                NSLog(@" Response  : %@", response);
                schoolsArray = (NSMutableArray *)[[Parse sharedParse] parseSchoolsListResponse:[response objectForKey:@"body"]];
                [self chooseContentView];
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

/**
 * Delete school from the parents list of schools
 * Param school object
 */
- (void)deleSchool:(SCHOOL_MODEL *)school{
    [[ProgressHUD sharedProgressHUD] showActivityIndicatorOnView:self.view];
    [ServiceModel makePostRequestWithOutBodyFor:DeleteSchool WithInputParameters:[NSString stringWithFormat:@"SchoolUniqueId=%@&ParentRef=%@&requestedOn=%@&requestedFrom=%@&geoLocation=%@",school.SchoolUniqueId,[[NSUserDefaults standardUserDefaults] objectForKey:UserRef],[appDelegate getStringFromDate:[NSDate date] withFormat:@"dd-MM-yyyy%20hh:mm:ss"],@"Mobile", [appDelegate currentLocation]]  AndToken:[[NSUserDefaults standardUserDefaults] objectForKey:AccessToken] MakeHttpRequest:^(NSDictionary *response, NSError *error){
        dispatch_async(dispatch_get_main_queue(), ^{
            [[ProgressHUD sharedProgressHUD] removeHUD];
            if (!error) {
                NSLog(@" Response  : %@", response);
                if ([[response objectForKey:@"body"] objectForKey:@"message"]) {
                    [[AlertMessage sharedAlert] showAlertWithMessage:[[response objectForKey:@"body"] objectForKey:@"message"] withDelegate:nil onViewController:self];
                    [self fetchSchoolsList];
                }
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

- (void)showSchoolsListView{
    //[self removeAndReloadView];
    if (!schoolsListViewController) {
        schoolsListViewController = [storyboard instantiateViewControllerWithIdentifier:@"SchoolsListViewController"];
        [schoolsListViewController setSchoolsListViewControllerDelegate:self];
    }
    [schoolsListViewController.view setFrame:self.containerView.bounds];
    [schoolsListViewController setSchoolsArray:schoolsArray];
    [schoolsListViewController updateSchoolsList];
    [self.containerView addSubview:schoolsListViewController.view];
}

- (void)showAddSchoolView{
    //[self removeAndReloadView];
    if (!addSchoolViewController) {
        addSchoolViewController = [storyboard instantiateViewControllerWithIdentifier:@"AddSchoolViewController"];
        [addSchoolViewController setAddSchoolViewControllerDelegate:self];
    }
    [addSchoolViewController.view setFrame:self.containerView.bounds];
    
    [self.containerView addSubview:addSchoolViewController.view];
}

- (void)removeAndReloadView{
    NSArray *viewsToRemove = [self.containerView subviews];
    if (viewsToRemove.count > 0) {
        for (UIView *v in viewsToRemove) {
            [v removeFromSuperview];
        }
    }else{
        return;
    }
    
}

/**
 * Fetching schools list added by parent
 */
- (void)fetchKidsListForSchool:(SCHOOL_MODEL *)school{
    
    [[ProgressHUD sharedProgressHUD] showActivityIndicatorOnView:self.view];
    [ServiceModel makeGetRequestFor:KidsList WithInputParams:[NSString stringWithFormat:@"parentUserRef=%@&userRef=%@&requestedon=%@&requestedfrom=%@&guid=%@&geolocation=%@",[[NSUserDefaults standardUserDefaults] objectForKey:UserRef],[[NSUserDefaults standardUserDefaults] objectForKey:UserRef],[appDelegate getStringFromDate:[NSDate date] withFormat:@"dd-MM-yyyy%20HH:MM:SS"],@"Mobile",[appDelegate getUUID],[appDelegate currentLocation]] AndToken:[[NSUserDefaults standardUserDefaults] objectForKey:AccessToken] MakeHttpRequest:^(NSDictionary *response, NSError *error){
        dispatch_async(dispatch_get_main_queue(), ^{
            [[ProgressHUD sharedProgressHUD] removeHUD];
            if (!error) {
                NSLog(@" Response  : %@", response);
                NSArray *tempArray = (NSMutableArray *)[[Parse sharedParse] parseKidsListResponse:[response objectForKey:@"body"]];
                
                NSArray *kidsArray = [tempArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SchoolUniqueId = %@",school.SchoolUniqueId]];
                if (kidsArray.count > 0) {
                    KidsListViewController *kidsListViewController = [storyboard instantiateViewControllerWithIdentifier:@"KidsListViewController"];
                    [kidsListViewController setKidsArray:kidsArray];
                    [kidsListViewController setFromSchoolFlag:true];
                    [kidsListViewController setSelectedSchool:school];
                    [kidsListViewController setTitle:school.SchoolName];
                    [kidsListViewController setKidsListViewControllerDelegate:self];
                    [self.navigationController pushViewController:kidsListViewController animated:YES];
                }else{
                    [[AlertMessage sharedAlert] showAlertWithMessage:@"There are no kids to display" withDelegate:nil onViewController:self];
                }
                
                
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

/**
 * Delete kid from the parent kids list
 * Param school object
 */
- (void)deleKid:(KID_MODEL *)kid{
    [[ProgressHUD sharedProgressHUD] showActivityIndicatorOnView:self.view];
    [ServiceModel makePostRequestWithOutBodyFor:DeleteKid WithInputParameters:[NSString stringWithFormat:@"KidId=%@&ParentRef=%@&requestedOn=%@&requestedFrom=%@&geoLocation=%@",kid.kidId,[[NSUserDefaults standardUserDefaults] objectForKey:UserRef],[appDelegate getStringFromDate:[NSDate date] withFormat:@"dd-MM-yyyy%20hh:mm:ss"],@"Mobile", [appDelegate currentLocation]]  AndToken:[[NSUserDefaults standardUserDefaults] objectForKey:AccessToken] MakeHttpRequest:^(NSDictionary *response, NSError *error){
        dispatch_async(dispatch_get_main_queue(), ^{
            [[ProgressHUD sharedProgressHUD] removeHUD];
            if (!error) {
                NSLog(@" Response  : %@", response);
                if ([[response objectForKey:@"body"] objectForKey:@"message"]) {
                    [[AlertMessage sharedAlert] showAlertWithMessage:[[response objectForKey:@"body"] objectForKey:@"message"] withDelegate:nil onViewController:self];
                }
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
#pragma -mark AddSchoolViewControllerProtocol methods
- (void)didSchoolAdded{
    [self fetchSchoolsList];
}

#pragma -mark SchoolsListViewControllerProtocol methods
- (void)addNewSchool{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    AddSchoolViewController *viewController = (AddSchoolViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"AddSchoolViewController"];
    [viewController setAddSchoolViewControllerDelegate:self];
    [viewController setFromSchoolistPage:true];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)didSelecteDeleteSchool:(SCHOOL_MODEL *)schoolToDelete{
    [self deleSchool:schoolToDelete];
}

- (void)didSelectSchool:(SCHOOL_MODEL *)selectedSchool{
    [self fetchKidsListForSchool:selectedSchool];
}

#pragma -mark AlertMessageDelegateProtocol Methods
- (void)clickedOkButton{
    [[SharedManager sharedManager] logoutTheUser];
    [[SharedManager sharedManager] showLoginScreen];
}

#pragma -mark KidsListViewControllerProtocol Methods
- (void)didDeleteKid:(KID_MODEL *)kid{
    [self deleKid:kid];
}
@end

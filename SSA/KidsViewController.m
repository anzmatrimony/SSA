//
//  KidsViewController.m
//  SSA
//
//  Created by Sunera on 4/30/17.
//  Copyright © 2017 surya. All rights reserved.
//

#import "KidsViewController.h"
#import "ProgressHUD.h"
#import "ServiceModel.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "Parse.h"
#import "AlertMessage.h"
#import "SharedManager.h"
#import "Firebase.h"

@interface KidsViewController ()<AlertMessageDelegateProtocol>
{
    NSMutableArray *kidsArray;
    KidsListViewController *kidsListViewController;
    AddKidViewController *addKidViewController;
    UIStoryboard *storyboard;
    FIRDatabaseReference *kidRef;
}
//private lazy var channelRef: DatabaseReference = Database.database().reference().child("channels")

@property (nonatomic, weak) IBOutlet UIView *containerView;
@end

@implementation KidsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    kidRef = [[[FIRDatabase database] reference] child:@"Kids"];
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    self.tabBarItem.selectedImage = [[UIImage imageNamed:@"kids-blue.png"]
                                     imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.tabBarItem.image = [[UIImage imageNamed:@"kids-blue.png"]
                             imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

- (void)viewWillAppear:(BOOL)animated{
    kidsArray = [[NSMutableArray alloc] init];
    //[kidsArray addObject:@"school"];
    
    NSString * storyboardName = @"Main";
    storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    
    [self fetchKidsList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)chooseContentView{
    
    if (kidsArray.count > 0) {
        [self showKidsListView];
    }else{
        [self showAddKidView];
    }
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
                [self addKidsInFirebaseIfNotAdded];
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

- (void)addKidsInFirebaseIfNotAdded{
    //NSString *uid = [[[FIRAuth auth] currentUser] uid];
    //FIRDatabaseReference *newKidRef = [kidRef child:uid];
//    for (KID_MODEL *kid in kidsArray) {
//        
//        FIRDatabaseReference *newKidRef = [kidRef child:kid.kidId];
//        
//        [newKidRef setValue:@{@"kidId":kid.kidId, @"kidName":kid.firstName, @"schoolUniqueId":kid.SchoolUniqueId, @"parentId":kid.parentUserRef,@"messages":@""}];
//        /*[[[kidRef queryOrderedByChild:@"kidId"] queryEqualToValue:kid.kidId] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapShot){
//            if ([snapShot value] == nil) {
//                [kidRef setValue:@{@"kidId":kid.kidId}];
//            }
//        }];*/
//    }
    
    FIRDatabaseReference *ref = [[FIRDatabase database] reference];
    
    for (KID_MODEL *kid in kidsArray) {
        [[ref child:@"Kids"] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapShot){
            if (![snapShot hasChild:kid.kidId]) {
                FIRDatabaseReference *newKidRef;
                newKidRef = [kidRef child:kid.kidId];
                [newKidRef setValue:@{@"kidId":kid.kidId, @"kidName":kid.firstName, @"schoolUniqueId":kid.SchoolUniqueId, @"parentId":kid.parentUserRef,@"messages":@""}];
            }
        }];
    }
}
- (void)showKidsListView{
    //[self removeAndReloadView];
    if (!kidsListViewController) {
        kidsListViewController = [storyboard instantiateViewControllerWithIdentifier:@"KidsListViewController"];
        [kidsListViewController setKidsListViewControllerDelegate:self];
    }
    [kidsListViewController.view setFrame:self.containerView.bounds];
    [kidsListViewController setKidsArray:kidsArray];
    [kidsListViewController updateKidsList];
    [self.containerView addSubview:kidsListViewController.view];
}

- (void)showAddKidView{
    //[self removeAndReloadView];
    if (!addKidViewController) {
        addKidViewController = [storyboard instantiateViewControllerWithIdentifier:@"AddKidViewController"];
        [addKidViewController setAddKidViewControllerDelegate:self];
    }
    [addKidViewController.view setFrame:self.containerView.bounds];
    [addKidViewController fetchSchoolsList];
    [self.containerView addSubview:addKidViewController.view];
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

#pragma mark AddKidViewControllerProtocol methods
- (void)didKidAddedWithKidName:(NSString *)kidName AndSchoolName:(NSString *)schoolName{
    [self fetchKidsList];
}

#pragma mark KidsListViewControllerProtocol methods
- (void)addNewKid{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    AddKidViewController *viewController = (AddKidViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"AddKidViewController"];
    [viewController setAddKidViewControllerDelegate:self];
    [viewController setFromKidsListPage:true];
    [viewController fetchSchoolsList];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark AlertMessageDelegateProtocol methods
- (void)clickedOkButton{
    [[SharedManager sharedManager] logoutTheUser];
    [[SharedManager sharedManager] showLoginScreen];
}
@end

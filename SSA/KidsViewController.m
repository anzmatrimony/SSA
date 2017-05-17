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

@interface KidsViewController ()
{
    NSMutableArray *kidsArray;
    KidsListViewController *kidsListViewController;
    AddKidViewController *addKidViewController;
    UIStoryboard *storyboard;
}
@property (nonatomic, weak) IBOutlet UIView *containerView;
@end

@implementation KidsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate = [[UIApplication sharedApplication] delegate];
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
    [ServiceModel makeGetRequestFor:KidsList WithInputParams:[NSString stringWithFormat:@"parentUserRef=%@&userRef=%@&requestedon=%@&requestedfrom=%@&guid=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"UserRef"],[[NSUserDefaults standardUserDefaults] objectForKey:@"UserRef"],[appDelegate getStringFromDate:[NSDate date] withFormat:@"dd-MM-yyyy%20HH:MM:SS"],@"Mobile",[appDelegate getUUID]] MakeHttpRequest:^(NSDictionary *response, NSError *error){
        dispatch_async(dispatch_get_main_queue(), ^{
            [[ProgressHUD sharedProgressHUD] removeHUD];
            if (!error) {
                NSLog(@" Response  : %@", response);
                kidsArray = (NSMutableArray *)[[Parse sharedParse] parseKidsListResponse:[response objectForKey:@"body"]];
                [self chooseContentView];
            }else{
                NSLog(@" Error : %@", error.localizedDescription);
            }
            
        });
    }];
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
@end

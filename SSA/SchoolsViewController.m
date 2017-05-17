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

@interface SchoolsViewController ()
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
    [ServiceModel makeGetRequestFor:SchoolsList WithInputParams:[NSString stringWithFormat:@"userRef=%@&requestedon=%@&requestedfrom=%@&guid=%@&parentUserRef=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"UserRef"],[appDelegate getStringFromDate:[NSDate date] withFormat:@"dd-MM-yyyy%20hh:mm:ss"],@"Mobile",[appDelegate getUUID],[[NSUserDefaults standardUserDefaults] objectForKey:@"UserRef"]] MakeHttpRequest:^(NSDictionary *response, NSError *error){
        dispatch_async(dispatch_get_main_queue(), ^{
            [[ProgressHUD sharedProgressHUD] removeHUD];
            if (!error) {
                NSLog(@" Response  : %@", response);
                schoolsArray = (NSMutableArray *)[[Parse sharedParse] parseSchoolsListResponse:[response objectForKey:@"body"]];
                [self chooseContentView];
            }else{
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
@end

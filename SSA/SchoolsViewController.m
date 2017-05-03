//
//  SchoolsViewController.m
//  SSA
//
//  Created by Sunera on 4/30/17.
//  Copyright © 2017 surya. All rights reserved.
//

#import "SchoolsViewController.h"
#import "Constants.h"

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
    
    schoolsArray = [[NSMutableArray alloc] init];
    //[schoolsArray addObject:@"school"];
    
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

- (void)showSchoolsListView{
    //[self removeAndReloadView];
    if (!schoolsListViewController) {
        schoolsListViewController = [storyboard instantiateViewControllerWithIdentifier:@"SchoolsListViewController"];
        [schoolsListViewController setSchoolsListViewControllerDelegate:self];
    }
    [schoolsListViewController.view setFrame:self.containerView.bounds];
    [schoolsListViewController setSchoolsArray:schoolsArray];
    
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
    
    if (_containerView) {
        //[_containerView];
        //_controllerView = nil;
    }
}

#pragma -mark AddSchoolViewControllerProtocol methods
- (void)didSchoolAdded{
    [schoolsArray addObject:@"school"];
    [self chooseContentView];
    [schoolsListViewController updateSchoolsList];
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

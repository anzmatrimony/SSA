//
//  ActivitiesViewController.m
//  SSA
//
//  Created by Sunera on 4/30/17.
//  Copyright © 2017 surya. All rights reserved.
//

#import "ActivitiesViewController.h"
#import "ProgressHUD.h"
#import "ServiceModel.h"
#import "Parse.h"
#import "AppDelegate.h"
#import "AlertMessage.h"
#import "Parse.h"

@interface ActivitiesViewController ()
{
    KidsInActivityViewController *kidsInActivityViewController;
    ActivitiesListViewController *activitiesListViewController;
    UIStoryboard *storyboard;
    NSMutableArray *kidsArray;
}
@property (nonatomic, weak) IBOutlet UIView *containerView;
- (IBAction)segmentVolumeChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *kidsActivitySegment;

@end

@implementation ActivitiesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    NSString * storyboardName = @"Main";
    storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    
    //[self showKids];
    [self showActivities];
}

- (void)viewWillAppear:(BOOL)animated{
    //[self fetchKidsActivitiesList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)showKids{
    [self removeAndReloadView];
    if (!kidsInActivityViewController) {
        kidsInActivityViewController = [storyboard instantiateViewControllerWithIdentifier:@"KidsInActivityViewController"];
        //[kidsListViewController setSchoolsListViewControllerDelegate:self];
    }
    [kidsInActivityViewController.view setFrame:self.containerView.bounds];
    [kidsInActivityViewController setKidsArray:kidsArray];
    
    [self.containerView addSubview:kidsInActivityViewController.view];
}

- (void)showActivities{
    [self removeAndReloadView];
    if (!activitiesListViewController) {
        activitiesListViewController = [storyboard instantiateViewControllerWithIdentifier:@"ActivitiesListViewController"];
        //[activitiesListViewController setSchoolsListViewControllerDelegate:self];
    }
    [activitiesListViewController.view setFrame:self.containerView.bounds];
    //[activitiesListViewController setSchoolsArray:schoolsArray];
    
    [self.containerView addSubview:activitiesListViewController.view];
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
- (IBAction)segmentVolumeChanged:(id)sender {
    if (self.kidsActivitySegment.selectedSegmentIndex == 0) {
        [self showKids];
    }else{
        [self showActivities];
    }
}
@end

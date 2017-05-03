//
//  KidsViewController.m
//  SSA
//
//  Created by Sunera on 4/30/17.
//  Copyright © 2017 surya. All rights reserved.
//

#import "KidsViewController.h"

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
    
    kidsArray = [[NSMutableArray alloc] init];
    //[kidsArray addObject:@"school"];
    
    NSString * storyboardName = @"Main";
    storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    
    [self chooseContentView];
    
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


- (void)showKidsListView{
    //[self removeAndReloadView];
    if (!kidsListViewController) {
        kidsListViewController = [storyboard instantiateViewControllerWithIdentifier:@"KidsListViewController"];
        [kidsListViewController setKidsListViewControllerDelegate:self];
    }
    [kidsListViewController.view setFrame:self.containerView.bounds];
    [kidsListViewController setKidsArray:kidsArray];
    
    [self.containerView addSubview:kidsListViewController.view];
}

- (void)showAddKidView{
    //[self removeAndReloadView];
    if (!addKidViewController) {
        addKidViewController = [storyboard instantiateViewControllerWithIdentifier:@"AddKidViewController"];
        [addKidViewController setAddKidViewControllerDelegate:self];
    }
    [addKidViewController.view setFrame:self.containerView.bounds];
    
    [self.containerView addSubview:addKidViewController.view];
}

- (void)removeAndReloadView{
    
    if (_containerView) {
        //[_containerView];
        //_controllerView = nil;
    }
}

#pragma mark AddKidViewControllerProtocol methods
- (void)didKidAdded{
    [kidsArray addObject:@""];
    [self chooseContentView];
    [kidsListViewController updateKidsList];
}

#pragma mark KidsListViewControllerProtocol methods
- (void)addNewKid{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    AddKidViewController *viewController = (AddKidViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"AddKidViewController"];
    [viewController setAddKidViewControllerDelegate:self];
    [viewController setFromKidsListPage:true];
    [self.navigationController pushViewController:viewController animated:YES];
}
@end

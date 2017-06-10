//
//  BaseViewController.m
//  SSA
//
//  Created by Sunera on 6/6/17.
//  Copyright © 2017 surya. All rights reserved.
//

#import "BaseViewController.h"
#import "SharedManager.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addLogOutButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
@end

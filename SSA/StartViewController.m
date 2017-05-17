//
//  StartViewController.m
//  SSA
//
//  Created by Sunera on 5/15/17.
//  Copyright © 2017 surya. All rights reserved.
//

#import "StartViewController.h"
#import "SharedManager.h"

@interface StartViewController ()

@end

@implementation StartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Show starting screen based on the condition
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"LoginStatus"] != nil){
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginStatus"] isEqualToString:@"Success"]) {
            [[SharedManager sharedManager] showMPinScreen];
        }else{
            [[SharedManager sharedManager] showLoginScreen];
        }
    }else{
        [[SharedManager sharedManager] showLoginScreen];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

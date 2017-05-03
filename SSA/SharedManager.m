//
//  SharedManager.m
//  eSealCM
//
//  Created by Surya Narayana Vennala on 6/1/15.
//  Copyright (c) 2015 Surya Narayana Vennala. All rights reserved.
//

#import "SharedManager.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "MpinViewController.h"

@implementation SharedManager{
    UIViewController *viewController;
    LoginViewController *loginViewController;
    UITabBarController *tabBarController;
    UINavigationController *navigationController;
    MpinViewController *mPinViewController;
}

static SharedManager *singleTonManager;
+ (SharedManager *)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!singleTonManager) {
            singleTonManager = [[[self class] alloc] init];
        }
    });
    
    return singleTonManager;
}

- (void)showLoginScreen{
    if (loginViewController) {
        loginViewController = nil;
    }
    if(navigationController){
        navigationController = nil;
    }
    
    UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    navigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    
    [mainWindow setRootViewController:navigationController];
    [mainWindow makeKeyAndVisible];
}

- (void)showMPinScreen{
    if (mPinViewController) {
        mPinViewController = nil;
    }
    if(navigationController){
        navigationController = nil;
    }
    
    UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    mPinViewController = [storyboard instantiateViewControllerWithIdentifier:@"MpinViewController"];
    [mainWindow.rootViewController presentViewController:mPinViewController animated:YES completion:nil];
    [mainWindow makeKeyAndVisible];
}

- (void)showHomeScreen{
    if (tabBarController) {
        tabBarController = nil;
    }
    if(navigationController){
        navigationController = nil;
    }
    
    UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    tabBarController = [storyboard instantiateViewControllerWithIdentifier:@"TabsViewController"];
    
    //navigationController = [[UINavigationController alloc] initWithRootViewController:tabBarController];
    
    [mainWindow.rootViewController presentViewController:tabBarController animated:YES completion:nil];
    [mainWindow makeKeyAndVisible];
}

@end

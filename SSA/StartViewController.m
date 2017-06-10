//
//  StartViewController.m
//  SSA
//
//  Created by Sunera on 5/15/17.
//  Copyright © 2017 surya. All rights reserved.
//

#import "StartViewController.h"
#import "SharedManager.h"
#import "THPinViewController.h"
#import "Constants.h"
#import "AppDelegate.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface StartViewController ()<THPinViewControllerDelegate,UIAlertViewDelegate>
{
    BOOL showEnterPinScreenFlag;
}
@property (nonatomic, copy) NSString *correctPin;
@property (nonatomic, assign) NSUInteger remainingPinEntries;


@end

static const NSUInteger THNumberOfPinEntries = 6;

@implementation StartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    showEnterPinScreenFlag = true;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"LoginStatus"] != nil){
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginStatus"] isEqualToString:@"Success"]) {
            _correctPin = [[NSUserDefaults standardUserDefaults] objectForKey:MPIN];
            if ([appDelegate isTouchIDAvailable]) {
                [self showTouchIdAlert];
            }else{
                [self performSelector:@selector(showPinViewAnimated:) withObject:nil afterDelay:1.0];
                //[self showPinViewAnimated:YES];
            }
            
            /*if (showEnterPinScreenFlag) {
                [self showPinViewAnimated:YES];
            }*/
            
        }else{
            [[SharedManager sharedManager] showLoginScreen];
        }
    }else{
        [[SharedManager sharedManager] showLoginScreen];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    //[self showTouchIdAlert];
    // Show starting screen based on the condition
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showTouchIdAlert{
    LAContext *myContext = [[LAContext alloc] init];
    NSError *authError = nil;
    NSString *myLocalizedReasonString = @"Are you device owner?";
    
    if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
        [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                  localizedReason:myLocalizedReasonString
                            reply:^(BOOL success, NSError *error) {
                                if (success) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [[SharedManager sharedManager] showHomeScreen];
                                    });
                                } else {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                    [self showPinViewAnimated:YES];
                                    });
                                    
                                    /*dispatch_async(dispatch_get_main_queue(), ^{
                                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                            message:error.description
                                                                                           delegate:self
                                                                                  cancelButtonTitle:@"OK"
                                                                                  otherButtonTitles:nil, nil];
                                        [alertView show];
                                        // Rather than show a UIAlert here, use the error to determine if you should push to a keypad for PIN entry.
                                    });*/
                                }
                            }];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showPinViewAnimated:YES];
        });
        /*dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:authError.description
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
            [alertView show];
            // Rather than show a UIAlert here, use the error to determine if you should push to a keypad for PIN entry.
        });*/
    }
}

- (void)applicationDidEnterBackground:(NSNotification *)notification
{
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification
                                                  object:nil];
}

#pragma mark - UI

- (void)showPinViewAnimated:(BOOL)animated
{
    showEnterPinScreenFlag = false;
    THPinViewController *pinViewController = [[THPinViewController alloc] initWithDelegate:self];
    pinViewController.promptTitle = @"Enter MPIN";
    UIColor *darkBlueColor = COLOR(34, 160, 208);
    pinViewController.promptColor = [UIColor whiteColor];
    pinViewController.view.tintColor = [UIColor whiteColor];
    
    // for a solid background color, use this:
    pinViewController.backgroundColor = darkBlueColor;
    
    pinViewController.disableCancel = true;
    
    //pinViewController.translucentBackground = YES;
    
    UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
    
    UIViewController *controller = (UIViewController *)[mainWindow rootViewController];
    
    [controller presentViewController:pinViewController animated:YES completion:nil];
}


#pragma mark - THPinViewControllerDelegate

- (NSUInteger)pinLengthForPinViewController:(THPinViewController *)pinViewController
{
    return 4;
}

- (BOOL)pinViewController:(THPinViewController *)pinViewController isPinValid:(NSString *)pin
{
    if ([pin isEqualToString:self.correctPin]) {
        return YES;
    } else {
        self.remainingPinEntries--;
        return NO;
    }
}

- (BOOL)userCanRetryInPinViewController:(THPinViewController *)pinViewController
{
    return (self.remainingPinEntries > 0);
}

- (void)incorrectPinEnteredInPinViewController:(THPinViewController *)pinViewController
{
    if (self.remainingPinEntries > THNumberOfPinEntries / 2) {
        return;
    }
    
    UIAlertView *alert =
    [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Incorrect PIN", @"")
                               message:(self.remainingPinEntries == 1 ?
                                        @"You can try again once." :
                                        [NSString stringWithFormat:@"You can try again %lu times.",
                                         (unsigned long)self.remainingPinEntries])
                              delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
}

- (void)pinViewControllerWillDismissAfterPinEntryWasSuccessful:(THPinViewController *)pinViewController
{
    [[SharedManager sharedManager] showHomeScreen];
}

- (void)pinViewControllerWillDismissAfterPinEntryWasUnsuccessful:(THPinViewController *)pinViewController
{
    
}

- (void)pinViewControllerWillDismissAfterPinEntryWasCancelled:(THPinViewController *)pinViewController
{
    
}

#pragma UIAlerViewDelegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@" Selected button index %ld",(long)buttonIndex);
    [self showPinViewAnimated:YES];
}

@end

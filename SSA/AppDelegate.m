//
//  AppDelegate.m
//  SSA
//
//  Created by Sunera on 4/29/17.
//  Copyright © 2017 surya. All rights reserved.
//

#import "AppDelegate.h"
#import "Constants.h"
#import "SharedManager.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "THPinViewController.h"

@interface AppDelegate ()<THPinViewControllerDelegate>
@property (nonatomic, copy) NSString *correctPin;
@property (nonatomic, assign) NSUInteger remainingPinEntries;
@end

static const NSUInteger THNumberOfPinEntries = 6;

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self initializeLocationManager];
    // Applying color to navigation bar and navigation bar title
    [[UINavigationBar appearance] setBarTintColor:COLOR(42, 103, 130)];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                               [UIColor whiteColor],UITextAttributeTextColor, nil];
    
    [[NSUserDefaults standardUserDefaults] setBool:true forKey:IsPointingToAWS];
    
    self.currentLocation = @"0.0,0.0";
    
    /*[[UINavigationBar appearance] setShadowImage:[UIImage new]];
    // is IOS 7 and later
    [[UINavigationBar appearance] setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    */
    [self customizeTabBarAppearance];
    
    // Changing status bar text color to Light(White)
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [FIRApp configure];
    
    return YES;
}

- (void)customizeTabBarAppearance{
    UIColor *backgroundColor = COLOR(0, 85, 113);
    // set the bar background color
    [[UITabBar appearance] setBackgroundImage:[AppDelegate imageFromColor:backgroundColor forSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width, 49) withCornerRadius:0]];
    // set the text color for selected state
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor, nil] forState:UIControlStateSelected];
    // set the text color for unselected state
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor, nil] forState:UIControlStateNormal];
    // set the selected icon color
    //[[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    //[[UITabBar appearance] setSelectedImageTintColor:[UIColor whiteColor]];
    // remove the shadow
    [[UITabBar appearance] setShadowImage:nil];
    // Set the dark color to selected tab (the dimmed background)
    [[UITabBar appearance] setSelectionIndicatorImage:[AppDelegate imageFromColor:COLOR(35, 35, 35) forSize:CGSizeMake([UIScreen mainScreen].bounds.size.width / 4, 49) withCornerRadius:0]];
    
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[NSUserDefaults standardUserDefaults] setBool:true forKey:IsTouchIdRequired];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:LoginStatus] isEqualToString:@"Success"]) {
        self.correctPin = [[NSUserDefaults standardUserDefaults] objectForKey:MPIN];
        //[self showPinViewAnimated:YES];
        if ([self isTouchIDAvailable]) {
            [self showTouchIdAlert];
        }else{
            [self showPinViewAnimated:YES];
        }
        
    }
    
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    
    /*if ([[NSUserDefaults standardUserDefaults] boolForKey:IsTouchIdRequired]) {
        [self showTouchIdAlert];
    }*/
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

+ (UIImage *)imageFromColor:(UIColor *)color forSize:(CGSize)size withCornerRadius:(CGFloat)radius
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Begin a new image that will be the new image with the rounded corners
    // (here with the size of an UIImageView)
    UIGraphicsBeginImageContext(size);
    
    // Add a clip before drawing anything, in the shape of an rounded rect
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius] addClip];
    // Draw your image
    [image drawInRect:rect];
    
    // Get the image, here setting the UIImageView image
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    // Lets forget about that we were drawing
    UIGraphicsEndImageContext();
    
    return image;
}


- (UIView *) leftViewForTextfiledWithImage:(NSString *)imageName withCornerRadius:(NSArray *)cornersList{
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TextFieldHeight, TextFieldHeight)];
    [leftView setBackgroundColor:COLOR(42, 103, 130)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, TextFieldHeight - 15, TextFieldHeight - 15)];
    [imageView setImage:[UIImage imageNamed:imageName]];
    imageView.center = leftView.center;
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [leftView addSubview:imageView];
    
    [self applyCornerRadiusForTheView:leftView withCorners:cornersList];
    return leftView;
}

- (void)applyCornerRadiusForTheView:(UIView *)view withCorners:(NSArray *)cornersList{
    if (cornersList != nil && cornersList.count > 0) {
        
        UIRectCorner corners = 0;
        
        for (NSNumber *num in cornersList) {
            corners |= [num integerValue];
        }
        UIBezierPath *maskPath = [UIBezierPath
                                  bezierPathWithRoundedRect:view.bounds
                                  byRoundingCorners:(corners)
                                  cornerRadii:CGSizeMake(7, 7)
                                  ];
        
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        
        maskLayer.frame = view.bounds;
        maskLayer.path = maskPath.CGPath;
        
        view.layer.mask = maskLayer;
    }
}

/*!
 * @discussion Generating JSON formatted data from NSDictionary
 * @return JSON formatted string as a NSData object
 */
- (NSData *)getJsonFormatedStringFrom:(NSMutableDictionary *)paramsDict{
    NSData *jsonData;
    NSError *error;
    
    jsonData = [NSJSONSerialization dataWithJSONObject:paramsDict
                                               options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                 error:&error];
    
    return jsonData;
}

- (NSString *)getUUID{
    
    // String lenght should be 10
    NSMutableString *returnString = [NSMutableString stringWithCapacity:10];
        
    NSString *numbers = @"0123456789";
        
    // First number cannot be 0
    [returnString appendFormat:@"%C", [numbers characterAtIndex:(arc4random() % ([numbers length]-1))+1]];
        
    for (int i = 1; i < 10; i++)
    {
        [returnString appendFormat:@"%C", [numbers characterAtIndex:arc4random() % [numbers length]]];
    }
        
    return [NSString stringWithFormat:@"%@ae",returnString];
    
    //return [[NSUUID UUID] UUIDString];
}

/**
 * @Discussion Getting string from date with desired format
 * @Param date as NSDate object
 * @Param dateFormat as NSString object
 * @Return NSString object
 */
- (NSString *)getStringFromDate:(NSDate *)date withFormat:(NSString *)dateFormat{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFormat];
    
    NSDate *currentDate = date;
    NSString *dateString = [formatter stringFromDate:currentDate];
    return dateString;
}

/**
 * @Discussion Initializing location manager to get user current location
 */
- (void)initializeLocationManager{
    if (locationManager == nil) {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
}

#pragma Mark CLLocationManagerDelegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.currentLocation = [NSString stringWithFormat:@"%f,%f",[[locations objectAtIndex:0] coordinate].latitude,[[locations objectAtIndex:0] coordinate].latitude];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    self.currentLocation = @"0.0,0.0";
}

/**
 *@Discussion checking wether touch id enabled or not
 */
- (BOOL)isTouchIDAvailable{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        return [[[LAContext alloc] init] canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil];
    }
    return NO;
}

- (void)showTouchIdAlert{
    LAContext *myContext = [[LAContext alloc] init];
    NSError *authError = nil;
    NSString *myLocalizedReasonString = @"Touch ID Test to secure your app";
    
    if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
        [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                  localizedReason:myLocalizedReasonString
                            reply:^(BOOL success, NSError *error) {
                                if (success) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [[NSUserDefaults standardUserDefaults] setBool:false forKey:IsTouchIdRequired];
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

#pragma mark - UI

- (void)showPinViewAnimated:(BOOL)animated
{
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
    //[[SharedManager sharedManager] showHomeScreen];
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

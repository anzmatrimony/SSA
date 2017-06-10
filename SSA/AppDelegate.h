//
//  AppDelegate.h
//  SSA
//
//  Created by Sunera on 4/29/17.
//  Copyright © 2017 surya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>{
    CLLocationManager *locationManager;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) NSString *currentLocation;

- (UIView *) leftViewForTextfiledWithImage:(NSString *)imageName withCornerRadius:(NSArray *)cornersList;
- (void)applyCornerRadiusForTheView:(UIView *)view withCorners:(NSArray *)cornersList;

- (NSData *)getJsonFormatedStringFrom:(NSMutableDictionary *)paramsDict;
- (NSString *)getUUID;
- (void)initializeLocationManager;
- (NSString *)getStringFromDate:(NSDate *)date withFormat:(NSString *)dateFormat;
- (BOOL)isTouchIDAvailable;
@end


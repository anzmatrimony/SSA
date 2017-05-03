//
//  AppDelegate.h
//  SSA
//
//  Created by Sunera on 4/29/17.
//  Copyright © 2017 surya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


- (UIView *) leftViewForTextfiledWithImage:(NSString *)imageName withCornerRadius:(NSArray *)cornersList;
- (void)applyCornerRadiusForTheView:(UIView *)view withCorners:(NSArray *)cornersList;
@end


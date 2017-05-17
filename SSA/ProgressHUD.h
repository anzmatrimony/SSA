//
//  ProgressHUD.h
//  BarcodeScanner
//
//  Created by Surya Narayana Vennala on 11/10/14.
//  Copyright (c) 2014 Draconis Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ProgressHUD : NSObject

+ (ProgressHUD *)sharedProgressHUD;

- (void)showActivityIndicatorOnView:(UIView *)view;
- (void)removeHUD;

@end

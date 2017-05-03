//
//  AlertMessage.h
//  BlueJarApp
//
//  Created by Sunera on 3/29/16.
//  Copyright © 2016 lptech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Constants.h"

@protocol AlertMessageDelegateProtocol;


@interface AlertMessage : NSObject<UIAlertViewDelegate>

+(AlertMessage *)sharedAlert;

@property (nonatomic, strong) id<AlertMessageDelegateProtocol> alertMessageDelegate;

- (void)showAlertWithMessage:(NSString *)message withDelegate:(nullable id)delegate onViewController:(UIViewController *)controller;
@end

@protocol AlertMessageDelegateProtocol <NSObject>

- (void)clickedOkButton;

@end
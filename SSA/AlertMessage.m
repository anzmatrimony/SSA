//
//  AlertMessage.m
//  BlueJarApp
//
//  Created by Sunera on 3/29/16.
//  Copyright © 2016 lptech. All rights reserved.
//

#import "AlertMessage.h"

@implementation AlertMessage

static AlertMessage *singleTonManager;
+ (AlertMessage *)sharedAlert{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!singleTonManager) {
            singleTonManager = [[[self class] alloc] init];
        }
    });
    
    return singleTonManager;
}

- (void)showAlertWithMessage:(NSString *)message withDelegate:(nullable id)delegate onViewController:(UIViewController *)controller {
    self.alertMessageDelegate = delegate;
    
    if (IS_OS_8_OR_LATER) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:AlertTitle
                                              message:message
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       if (self.alertMessageDelegate != nil) {
                                           if ([self.alertMessageDelegate respondsToSelector:@selector(clickedOkButton)]) {
                                               [self.alertMessageDelegate clickedOkButton];
                                           }

                                           NSLog(@"OK action");
                                       }
                                   }];
        [alertController addAction:okAction];
        [controller presentViewController:alertController animated:YES completion:nil];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:AlertTitle message:message delegate:delegate != nil ? self : nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        if ([self.alertMessageDelegate respondsToSelector:@selector(clickedOkButton)]) {
            [self.alertMessageDelegate clickedOkButton];
        }
    }
}
@end

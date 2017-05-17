//
//  ProgressHUD.m
//  BarcodeScanner
//
//  Created by Surya Narayana Vennala on 11/10/14.
//  Copyright (c) 2014 Draconis Software. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "ProgressHUD.h"

@interface ProgressHUD()

@property (nonatomic, strong)UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong)UIView *mainView;
@property (nonatomic, strong)UILabel *messageLabel;

@end

@implementation ProgressHUD

static ProgressHUD *singleTonHud = nil;

+ (ProgressHUD *)sharedProgressHUD{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (singleTonHud == nil) {
            singleTonHud = [[[self class] alloc] init];
        }
    });
    
    return singleTonHud;
}

- (void)showActivityIndicatorOnView:(UIView *)view{
    
    [self removeHUD];
    
    if (!_activityIndicator) {
        
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [_activityIndicator startAnimating];
        
        _mainView = [[UIView alloc] initWithFrame:CGRectMake(0,0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
        
        [_mainView setCenter:CGPointMake(view.bounds.size.width/2,
                                         view.bounds.size.height/2)];
        
        CGPoint activityFrame = _activityIndicator.center;
        activityFrame.x = _mainView.frame.size.width/2;
        activityFrame.y = _mainView.frame.size.height/2;
        
        [_activityIndicator setCenter:activityFrame];
        [_mainView addSubview:_activityIndicator];
        
        // Message label to show Loading message.  Added by surya
        /*_messageLabel = [[UILabel alloc] init];
         [_messageLabel setFrame:CGRectMake(10, (_mainView.frame.size.height/2)+25, 130, 20)];
         [_messageLabel setText:@"Loading Results"];
         [_messageLabel setTextColor:[UIColor whiteColor]];
         [_mainView addSubview:_messageLabel];*/
        
        [_mainView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
        
        [_mainView.layer setCornerRadius:5.0f];
        
        [view addSubview:_mainView];
    }
    
}

- (void)removeHUD{
    
    
    if (_mainView) {
        [_mainView removeFromSuperview];
        _mainView = nil;
    }
    
    if (_activityIndicator) {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
        [_activityIndicator stopAnimating];
        [_activityIndicator removeFromSuperview];
        _activityIndicator = nil;
    }
}

@end

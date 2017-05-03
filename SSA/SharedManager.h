//
//  SharedManager.h
//  eSealCM
//
//  Created by Surya Narayana Vennala on 6/1/15.
//  Copyright (c) 2015 Surya Narayana Vennala. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AppDelegate;

@interface SharedManager : NSObject{
    AppDelegate *appDelegate;
    
}

+(SharedManager *)sharedManager;


- (void)showLoginScreen;
- (void)showHomeScreen;
- (void)showMPinScreen;

@end

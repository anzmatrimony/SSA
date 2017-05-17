//
//  NewKidViewController.h
//  SSA
//
//  Created by Sunera on 5/15/17.
//  Copyright © 2017 surya. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AppDelegate;

@protocol NewKidViewControllerProtocol <NSObject>

- (void)didKidAdded;

@end
@interface NewKidViewController : UIViewController{
    AppDelegate *appDelegate;
}

@property (nonatomic, strong) id<NewKidViewControllerProtocol> addKidViewControllerDelegate;

@property (nonatomic, assign, getter=isFromKidsListPage) BOOL fromKidsListPage;

@end

//
//  KidsViewController.h
//  SSA
//
//  Created by Sunera on 4/30/17.
//  Copyright © 2017 surya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KidsListViewController.h"
#import "AddKidViewController.h"
#import "NewKidViewController.h"

@class AppDelegate;

@interface KidsViewController : UIViewController<AddKidViewControllerProtocol,KidsListViewControllerProtocol>
{
    AppDelegate *appDelegate;
}
@end

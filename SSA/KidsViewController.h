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
#import "BaseViewController.h"

@class AppDelegate;

@interface KidsViewController : BaseViewController<AddKidViewControllerProtocol,KidsListViewControllerProtocol>
{
    AppDelegate *appDelegate;
}
@end

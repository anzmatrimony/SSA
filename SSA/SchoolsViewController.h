//
//  SchoolsViewController.h
//  SSA
//
//  Created by Sunera on 4/30/17.
//  Copyright © 2017 surya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SchoolsListViewController.h"
#import "AddSchoolViewController.h"
#import "BaseViewController.h"
@class AppDelegate;

@interface SchoolsViewController : BaseViewController<AddSchoolViewControllerProtocol,SchoolsListViewControllerProtocol>
{
    AppDelegate *appDelegate;
}
@end

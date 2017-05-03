//
//  SchoolsListViewController.h
//  SSA
//
//  Created by Sunera on 4/30/17.
//  Copyright © 2017 surya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SchoolsListTableViewCell.h"

@protocol SchoolsListViewControllerProtocol <NSObject>

- (void)addNewSchool;

@end
@interface SchoolsListViewController : UIViewController
@property (nonatomic, strong) NSArray *schoolsArray;
@property (nonatomic, strong) id<SchoolsListViewControllerProtocol> schoolsListViewControllerDelegate;

- (void)updateSchoolsList;
@end

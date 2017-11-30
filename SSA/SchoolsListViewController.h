//
//  SchoolsListViewController.h
//  SSA
//
//  Created by Sunera on 4/30/17.
//  Copyright © 2017 surya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SchoolsListTableViewCell.h"
#import "ObjectManager.h"

@protocol SchoolsListViewControllerProtocol <NSObject>

- (void)addNewSchool;
- (void)didSelecteDeleteSchool:(SCHOOL_MODEL *)schoolToDelete;
- (void)didSelectSchool:(SCHOOL_MODEL *)selectedSchool;

@end
@interface SchoolsListViewController : UIViewController
@property (nonatomic, strong) NSArray *schoolsArray;
@property (nonatomic, strong) id<SchoolsListViewControllerProtocol> schoolsListViewControllerDelegate;

- (void)updateSchoolsList;
@end

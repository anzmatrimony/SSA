//
//  AddKidViewController.h
//  SSA
//
//  Created by Sunera on 5/1/17.
//  Copyright © 2017 surya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ObjectManager.h"
#import "KidsPhotosViewController.h"

@class AppDelegate;

@protocol AddKidViewControllerProtocol <NSObject>

- (void)didKidAddedWithKidName:(NSString *)kidName AndSchoolName:(NSString *)schoolName;

@end
@interface AddKidViewController : UIViewController <KidsPhotosViewControllerProtocol>{
    AppDelegate *appDelegate;
}


@property (nonatomic, strong) id<AddKidViewControllerProtocol> addKidViewControllerDelegate;

@property (nonatomic, assign, getter=isFromKidsListPage) BOOL fromKidsListPage;
@property (nonatomic, assign, getter=isFromSchoolPage) BOOL fromSchoolPage;
@property (nonatomic, strong) SCHOOL_MODEL *selectedSchool;

- (void)fetchSchoolsList;

@end

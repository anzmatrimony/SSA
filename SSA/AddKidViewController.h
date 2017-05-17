//
//  AddKidViewController.h
//  SSA
//
//  Created by Sunera on 5/1/17.
//  Copyright © 2017 surya. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppDelegate;

@protocol AddKidViewControllerProtocol <NSObject>

- (void)didKidAddedWithKidName:(NSString *)kidName AndSchoolName:(NSString *)schoolName;

@end
@interface AddKidViewController : UIViewController{
    AppDelegate *appDelegate;
}


@property (nonatomic, strong) id<AddKidViewControllerProtocol> addKidViewControllerDelegate;

@property (nonatomic, assign, getter=isFromKidsListPage) BOOL fromKidsListPage;

- (void)fetchSchoolsList;

@end

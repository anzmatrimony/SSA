//
//  AddSchoolViewController.h
//  SSA
//
//  Created by Sunera on 4/30/17.
//  Copyright © 2017 surya. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddSchoolViewControllerProtocol <NSObject>

- (void)didSchoolAdded;

@end
@interface AddSchoolViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIView *addSchoolUIDNumberBackgroundview,*confirmSchoolBackgroundView;
@property (nonatomic, weak) IBOutlet UIView *addSchoolImageBackgroundView,*confirmSchoolImageBackgroundView;
@property (nonatomic, weak) IBOutlet UIImageView *addSchoolImageView,*confirmSchoolImageView;
@property (nonatomic, weak) IBOutlet UITextField *UIDNumberField;

@property (nonatomic, assign, getter=isFromSchoolList) BOOL fromSchoolistPage;
@property (nonatomic, strong) id<AddSchoolViewControllerProtocol> addSchoolViewControllerDelegate;

@end

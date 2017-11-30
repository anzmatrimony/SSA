//
//  AddSchoolViewController.h
//  SSA
//
//  Created by Sunera on 4/30/17.
//  Copyright © 2017 surya. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  AppDelegate;
@protocol AddSchoolViewControllerProtocol <NSObject>

- (void)didSchoolAdded;

@end
@interface AddSchoolViewController : UIViewController<UITextFieldDelegate>{
    AppDelegate *appDelegate;
}

@property (nonatomic, weak) IBOutlet UIView *addSchoolUIDNumberBackgroundview,*confirmSchoolBackgroundView;
@property (nonatomic, weak) IBOutlet UIView *addSchoolImageBackgroundView,*confirmSchoolImageBackgroundView;
@property (nonatomic, weak) IBOutlet UIImageView *addSchoolImageView,*confirmSchoolImageView;
@property (nonatomic, weak) IBOutlet UITextField *UIDNumberField;
@property (nonatomic, weak) IBOutlet UILabel *schoolNameLabel,*schoolAddressLabel,*uidLabel;

@property (nonatomic, assign, getter=isFromSchoolList) BOOL fromSchoolistPage;
@property (nonatomic, strong) id<AddSchoolViewControllerProtocol> addSchoolViewControllerDelegate;

@end

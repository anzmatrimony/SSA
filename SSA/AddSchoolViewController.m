//
//  AddSchoolViewController.m
//  SSA
//
//  Created by Sunera on 4/30/17.
//  Copyright © 2017 surya. All rights reserved.
//

#import "AddSchoolViewController.h"
#import "Constants.h"

@interface AddSchoolViewController ()
{
    UITextField *activeTextField;
}
- (IBAction)addSchoolUIDNumberAction:(id)sender;
- (IBAction)confirmSchoolAction:(id)sender;
@end

@implementation AddSchoolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_addSchoolImageBackgroundView.layer setCornerRadius:50/2];
    [_addSchoolImageView.layer setCornerRadius:40/2];
    [_addSchoolImageView.layer setMasksToBounds:true];
    
    [_confirmSchoolImageBackgroundView.layer setCornerRadius:50/2];
    [_confirmSchoolImageView.layer setCornerRadius:40/2];
    [_confirmSchoolImageView.layer setMasksToBounds:true];
    
    [_addSchoolUIDNumberBackgroundview setHidden:false];
    [_confirmSchoolBackgroundView setHidden:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addSchoolUIDNumberAction:(id)sender{
    if ([_UIDNumberField.text length] != 0) {
        [_addSchoolUIDNumberBackgroundview setHidden:true];
        [_confirmSchoolBackgroundView setHidden:false];
        [_confirmSchoolImageView setImage:[UIImage imageNamed:@"confirmSchool-black-Active.png"]];
        [_addSchoolImageView setImage:[UIImage imageNamed:@"addSchool-black.png"]];
    }
}

- (IBAction)confirmSchoolAction:(id)sender{
    // Need to show alert
    
    if ([self.addSchoolViewControllerDelegate respondsToSelector:@selector(didSchoolAdded)]) {
        [self.addSchoolViewControllerDelegate didSchoolAdded];
    }
    if (self.isFromSchoolList) {
        self.fromSchoolistPage = false;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UITextField Delegate Methods
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    activeTextField = textField;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    activeTextField = nil;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return true;
}
@end

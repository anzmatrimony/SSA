//
//  AddKidViewController.m
//  SSA
//
//  Created by Sunera on 5/1/17.
//  Copyright © 2017 surya. All rights reserved.
//

#import "AddKidViewController.h"
#import "Constants.h"

@interface AddKidViewController (){
    UITextField *activeTextField;
}

@property (nonatomic, weak) IBOutlet UITextField *firstNameField,*lastNameField;
@property (nonatomic, weak) IBOutlet UIView *classBackgroundView,*sectionBackgroundView,*relationsShipBackgroundView,*chooseImageBackgroundView;
@property (nonatomic, weak) IBOutlet UIImageView *addKidImageView;

- (IBAction)submitAction:(id)sender;
@end

@implementation AddKidViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_addKidImageView.layer setCornerRadius:20];
    [_addKidImageView.layer setMasksToBounds:true];
    
    [self applyDesignToView:_firstNameField];
    [self applyDesignToView:_lastNameField];
    
    [self applyDesignToView:_classBackgroundView];
    [self applyDesignToView:_sectionBackgroundView];
    [self applyDesignToView:_relationsShipBackgroundView];
    [self applyDesignToView:_chooseImageBackgroundView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)applyDesignToView:(UIView *)viewObj{
    [viewObj.layer setCornerRadius:0];
    [viewObj.layer setBorderWidth:1];
    [viewObj.layer setBorderColor:COLOR(189, 218, 225).CGColor];
    [viewObj setBackgroundColor:COLOR(250, 254, 255)];
}

- (IBAction)submitAction:(id)sender{
    // validation
    if ([self.addKidViewControllerDelegate respondsToSelector:@selector(didKidAdded)]) {
        [self.addKidViewControllerDelegate didKidAdded];
    }
    
    if ([self isFromKidsListPage]) {
        self.fromKidsListPage = false;
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

//
//  LoginViewController.m
//  SSA
//
//  Created by Sunera on 4/30/17.
//  Copyright © 2017 surya. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "AlertMessage.h"

@interface LoginViewController (){
    UITextField *activeTextField;
    BOOL isRememberMeSelected;
}

@property (nonatomic, weak) IBOutlet UITextField *userNameField,*passwordField;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *userNameFieldHeight,*passwordTextFieldHeight;
@property (nonatomic, weak) IBOutlet UIButton *rememberMeCheckBoxButton;
- (IBAction)loginAction:(id)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isRememberMeSelected = false;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    self.navigationController.navigationBar.translucent = NO;
    
    _userNameFieldHeight.constant = TextFieldHeight;
    _passwordTextFieldHeight.constant = TextFieldHeight;
    
    NSMutableArray *userNamefiledLeftViewCornersArray1 = [[NSMutableArray alloc] init];
    [userNamefiledLeftViewCornersArray1 addObject:[NSNumber numberWithInteger:UIRectCornerTopLeft]];
    _userNameField.leftView = [appDelegate leftViewForTextfiledWithImage:@"user.png" withCornerRadius:userNamefiledLeftViewCornersArray1];
    _userNameField.leftViewMode = UITextFieldViewModeAlways;
    
    NSMutableArray *passwordfiledLeftViewCornersArray1 = [[NSMutableArray alloc] init];
    [passwordfiledLeftViewCornersArray1 addObject:[NSNumber numberWithInteger:UIRectCornerBottomLeft]];
    _passwordField.leftView = [appDelegate leftViewForTextfiledWithImage:@"pswd.png" withCornerRadius:passwordfiledLeftViewCornersArray1];
    _passwordField.leftViewMode = UITextFieldViewModeAlways;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewDidDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)rememberMeAction:(id)sender{
    if (isRememberMeSelected) {
        [_rememberMeCheckBoxButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }else{
        [_rememberMeCheckBoxButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    isRememberMeSelected = !isRememberMeSelected;
}
- (IBAction)loginAction:(id)sender{
    if ([self doValidation]) {
        
    }
}

// Validating user inputs
- (BOOL)doValidation{
    if (_userNameField.text.length == 0 || _passwordField.text.length == 0) {
        [[AlertMessage sharedAlert] showAlertWithMessage:AlertTitle withDelegate:@"Please fill all the fields" onViewController:self];
        return YES;
    }
    return false;
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

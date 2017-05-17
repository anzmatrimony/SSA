//
//  MpinViewController.m
//  SSA
//
//  Created by Sunera on 4/30/17.
//  Copyright © 2017 surya. All rights reserved.
//

#import "MpinViewController.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "SharedManager.h"
#import "AlertMessage.h"

@interface MpinViewController ()
{
    UITextField *activeTextField;
}

@property (nonatomic, weak) IBOutlet UITextField *mpinTextField,*confirmMpinTextField;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *mpinTextFieldHeight,*confirmMpinTextFieldHeight;
- (IBAction)confirmSetMpinAction:(id)sender;

@end

@implementation MpinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    [self applyDesignsToTextFields];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)applyDesignsToTextFields{
    
    _mpinTextFieldHeight.constant = TextFieldHeight;
    _confirmMpinTextFieldHeight.constant = TextFieldHeight;
    
    NSMutableArray *mpinfiledLeftViewCornersArray1 = [[NSMutableArray alloc] init];
    [mpinfiledLeftViewCornersArray1 addObject:[NSNumber numberWithInteger:UIRectCornerTopLeft]];
    _mpinTextField.leftView = [appDelegate leftViewForTextfiledWithImage:@"Person.png" withCornerRadius:mpinfiledLeftViewCornersArray1];
    _mpinTextField.leftViewMode = UITextFieldViewModeAlways;
    
    NSMutableArray *confirmMpinFeldLeftViewCornersArray1 = [[NSMutableArray alloc] init];
    [confirmMpinFeldLeftViewCornersArray1 addObject:[NSNumber numberWithInteger:UIRectCornerBottomLeft]];
    _confirmMpinTextField.leftView = [appDelegate leftViewForTextfiledWithImage:@"Person.png" withCornerRadius:confirmMpinFeldLeftViewCornersArray1];
    _confirmMpinTextField.leftViewMode = UITextFieldViewModeAlways;
}

- (IBAction)confirmSetMpinAction:(id)sender{
    if ([self doValidation]) {
        NSLog(@" Login Status : %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginStatus"]);
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginStatus"] isEqualToString:@"InProcess"]) {
            [[NSUserDefaults standardUserDefaults] setObject:_mpinTextField.text forKey:@"MPIN"];
            [[NSUserDefaults standardUserDefaults] setObject:@"Success" forKey:@"LoginStatus"];
            [[SharedManager sharedManager] showHomeScreen];
        }else{
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"MPIN"] isEqualToString:_mpinTextField.text]) {
                [[SharedManager sharedManager] showHomeScreen];
            }else{
                [[AlertMessage sharedAlert] showAlertWithMessage:@"Enter valid pin" withDelegate:nil onViewController:self];
            }
        }
    }
}

// Validating user inputs
- (BOOL)doValidation{
    if (_mpinTextField.text.length == 0 || _confirmMpinTextField.text.length == 0) {
        [[AlertMessage sharedAlert] showAlertWithMessage:@"Please fill all the fields" withDelegate:nil onViewController:self];
        return NO;
    }else if (![_mpinTextField.text isEqualToString:_confirmMpinTextField.text]){
        [[AlertMessage sharedAlert] showAlertWithMessage:@"Pin and Confirm pin must be same" withDelegate:nil onViewController:self];
        return NO;
    }
    return true;
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

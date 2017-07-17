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
#import "SharedManager.h"
#import "ProgressHUD.h"
#import "ServiceModel.h"
#import "Parse.h"
#import "Firebase.h"
#import "MpinViewController.h"
#import "ForgotPasswordViewController.h"

@interface LoginViewController (){
    UITextField *activeTextField;
    BOOL isRememberMeSelected;
}

@property (nonatomic, weak) IBOutlet UITextField *userNameField,*passwordField;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *userNameFieldHeight,*passwordTextFieldHeight;
@property (nonatomic, weak) IBOutlet UIButton *rememberMeCheckBoxButton;
- (IBAction)loginAction:(id)sender;
- (IBAction)rememberMeAction:(id)sender;
- (IBAction)forgotPasswordAction:(id)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isRememberMeSelected = [[NSUserDefaults standardUserDefaults] boolForKey:RememberMeStatus];
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
    
    if (isRememberMeSelected) {
        _userNameField.text = [[NSUserDefaults standardUserDefaults] objectForKey:UserName];
        _passwordField.text = [[NSUserDefaults standardUserDefaults] objectForKey:Password];
        [_rememberMeCheckBoxButton setImage:[UIImage imageNamed:@"checkIcon.png"] forState:UIControlStateNormal];
    }
    
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
        [_rememberMeCheckBoxButton setImage:[UIImage imageNamed:@"black-check-box.png"] forState:UIControlStateNormal];
    }else{
        [_rememberMeCheckBoxButton setImage:[UIImage imageNamed:@"checkIcon.png"] forState:UIControlStateNormal];
    }
    isRememberMeSelected = !isRememberMeSelected;
    [[NSUserDefaults standardUserDefaults] setBool:isRememberMeSelected forKey:RememberMeStatus];
}
- (IBAction)loginAction:(id)sender{
    if ([self doValidation]) {
        [[ProgressHUD sharedProgressHUD] showActivityIndicatorOnView:self.view];
        [ServiceModel getTokenWithUserName:[_userNameField.text lowercaseString] AndPassword:_passwordField.text GetAccessToken:^(NSDictionary *response, NSError *error){
            dispatch_async(dispatch_get_main_queue(), ^{
                [[ProgressHUD sharedProgressHUD] removeHUD];
                if (!error) {
                    if([response objectForKey:@"error"]){
                        [[AlertMessage sharedAlert] showAlertWithMessage:@"Authentication failed" withDelegate:nil onViewController:self];
                    }else{
                        [[NSUserDefaults standardUserDefaults] setObject:[response objectForKey:@"access_token"] forKey:AccessToken];
                        [self fetchProfileInfo];
                        /*[[NSUserDefaults standardUserDefaults] setObject:[response objectForKey:@"access_token"] forKey:AccessToken];
                        [[NSUserDefaults standardUserDefaults] setObject:@"InProcess" forKey:@"LoginStatus"];
                        [[NSUserDefaults standardUserDefaults] setObject:_userNameField.text forKey:UserRef];
                        NSLog(@" Login Status : %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginStatus"]);
                        [[SharedManager sharedManager] showMPinScreen];*/
                    }
                    NSLog(@"Response %@",response);
                }else{
                    [[AlertMessage sharedAlert] showAlertWithMessage:@"Invalid Credentials" withDelegate:nil onViewController:self];
                }
            });
        }];
        /*if ([_userNameField.text isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"UserName"]] && [_passwordField.text isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"Password"]]) {
            [[NSUserDefaults standardUserDefaults] setObject:@"InProcess" forKey:@"LoginStatus"];
            NSLog(@" Login Status : %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginStatus"]);
            [[SharedManager sharedManager] showMPinScreen];
        }else{
            [[AlertMessage sharedAlert] showAlertWithMessage:@"Invalid credentials" withDelegate:nil onViewController:self];
        }*/
    }
}

- (IBAction)forgotPasswordAction:(id)sender{
//    // show forgot password screen
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
//    ForgotPasswordViewController *forgotPasswordViewController = [storyboard instantiateViewControllerWithIdentifier:@"ForgotPasswordViewController"];
//    [self.navigationController pushViewController:forgotPasswordViewController animated:YES];
}

/**
 *@Discussion fetching user profile upon successfull login
 */
- (void)fetchProfileInfo{
    
    [[ProgressHUD sharedProgressHUD] showActivityIndicatorOnView:self.view];
    [ServiceModel makeGetRequestFor:GetProfile WithInputParams:[NSString stringWithFormat:@"userId=%@&requestedOn=%@&requestedFrom=%@&guid=%@&userRef=%@&geoLocation=%@",_userNameField.text,[appDelegate getStringFromDate:[NSDate date] withFormat:@"dd-MM-yyyy%20hh:mm:ss"],@"Mobile",[appDelegate getUUID],_userNameField.text, [appDelegate currentLocation]] AndToken:[[NSUserDefaults standardUserDefaults] objectForKey:AccessToken] MakeHttpRequest:^(NSDictionary *response, NSError *error){
        dispatch_async(dispatch_get_main_queue(), ^{
            [[ProgressHUD sharedProgressHUD] removeHUD];
            if (!error) {
                if([response objectForKey:@"error"]){
                    [[AlertMessage sharedAlert] showAlertWithMessage:@"Authentication failed" withDelegate:nil onViewController:self];
                }else{
                    if([[response objectForKey:@"body"] objectForKey:@"message"]){
                        [[AlertMessage sharedAlert] showAlertWithMessage:[[response objectForKey:@"body"] objectForKey:@"message"] withDelegate:nil onViewController:self];
                    }else{
                       
                        [[NSUserDefaults standardUserDefaults] setObject:_userNameField.text forKey:UserName];
                        [[NSUserDefaults standardUserDefaults] setObject:_passwordField.text forKey:Password];
                        
                        [[NSUserDefaults standardUserDefaults] setObject:@"InProcess" forKey:@"LoginStatus"];
                        [[NSUserDefaults standardUserDefaults] setObject:[[response objectForKey:@"body"] objectForKey:@"userRef"] forKey:UserRef];
                        [[NSUserDefaults standardUserDefaults] setObject:[[response objectForKey:@"body"] objectForKey:@"Role"] forKey:Role];
                        [[NSUserDefaults standardUserDefaults] setObject:[[response objectForKey:@"body"] objectForKey:@"status"] forKey:UserStatus];
                        NSLog(@" Login Status : %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginStatus"]);
                        
                        if([[[NSUserDefaults standardUserDefaults] objectForKey:Role] isEqualToString:@"CT"] || [[[NSUserDefaults standardUserDefaults] objectForKey:Role] isEqualToString:@"SU"]){
                            [[NSUserDefaults standardUserDefaults] setObject:[[response objectForKey:@"body"] objectForKey:@"SchoolUniqueId"] forKey:schoolUniqueId];
                            
                            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@ %@",[[response objectForKey:@"body"] objectForKey:@"firstName"],[[response objectForKey:@"body"] objectForKey:@"lastName"]] forKey:TeacherName];
                        }
                        
                        [self registerInFireBase];
                        //[[SharedManager sharedManager] showMPinScreen];
                        
                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                        MpinViewController *mPinViewController = [storyboard instantiateViewControllerWithIdentifier:@"MpinViewController"];
                        [self.navigationController pushViewController:mPinViewController animated:YES];
                    } 
                }
                NSLog(@"Response %@",response);
            }else{
                [[AlertMessage sharedAlert] showAlertWithMessage:error.localizedDescription withDelegate:nil onViewController:self];
            }
        });
    }];
}

/**
 *@discussion creating user in firebase
 */
- (void)registerInFireBase{
    [[FIRAuth auth] createUserWithEmail:_userNameField.text password:_passwordField.text completion:^(FIRUser *user, NSError *error){
        if (error == nil) {
            NSLog(@"User created successfully in firebase");
            [self loginUserInFireBase];
        }else{
            NSDictionary *userInfo = [error userInfo];
            NSString *errorName = [userInfo objectForKey:@"error_name"];
            if (errorName != nil && [errorName isEqualToString:@"ERROR_EMAIL_ALREADY_IN_USE"]) {
                [self loginUserInFireBase];
                return ;
            }
            NSLog(@"Problem occured while creating user");
            NSLog(@" Error : %@ ",error.localizedDescription);
        }
    }];
}

/**
 *@discussion login user in firebase
 */
- (void)loginUserInFireBase{
    [[FIRAuth auth] signInWithEmail:_userNameField.text password:_passwordField.text completion:^(FIRUser *user, NSError *error){
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@" user logged in successfully ");
            });
        }
    }];
}
// Validating user inputs
- (BOOL)doValidation{
    if (_userNameField.text.length == 0 || _passwordField.text.length == 0) {
        [[AlertMessage sharedAlert] showAlertWithMessage:@"Please fill all the fields" withDelegate:nil onViewController:self];
        return false;
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

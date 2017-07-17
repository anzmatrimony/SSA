//
//  ForgotPasswordViewController.m
//  SSA
//
//  Created by Sunera on 7/17/17.
//  Copyright © 2017 surya. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "AppDelegate.h"
#import "AlertMessage.h"
#import "ProgressHUD.h"
#import "ServiceModel.h"

@interface ForgotPasswordViewController ()<AlertMessageDelegateProtocol>
{
    UITextField *activeTextField;
}
@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    // Do any additional setup after loading the view.
    [_emailIdField setLeftView: [appDelegate leftViewForTextfiledWithImage:@"email.png" withCornerRadius:nil]];
    [self applyDesignToTextField:_emailIdField];
    [self getAccessToken];
}


- (void)applyDesignToTextField:(UITextField *)textField{
    [textField.layer setCornerRadius:0];
    [textField.layer setBorderWidth:1];
    [textField.layer setBorderColor:COLOR(189, 218, 225).CGColor];
    [textField setBackgroundColor:COLOR(250, 254, 255)];
    textField.leftViewMode = UITextFieldViewModeAlways;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *@discussion getting access token for registration
 */
- (void)getAccessToken{
    [[ProgressHUD sharedProgressHUD] showActivityIndicatorOnView:self.view];
    [ServiceModel GetAccessTokenWithOutPassword:^(NSDictionary *response, NSError *error){
        dispatch_async(dispatch_get_main_queue(), ^{
            [[ProgressHUD sharedProgressHUD] removeHUD];
            if (!error) {
                if ([response objectForKey:@"access_token"]) {
                    [[NSUserDefaults standardUserDefaults] setObject:[response objectForKey:@"access_token"] forKey:AccessToken];
                    //[self checkEmailExistence];
                    //[self registerParentWithToken:[response objectForKey:@"access_token"]];
                }else{
                    [[AlertMessage sharedAlert] showAlertWithMessage:@"Some thing went wrong. Please try again later." withDelegate:nil onViewController:self];
                }
                
            }else{
                [[AlertMessage sharedAlert] showAlertWithMessage:error.localizedDescription withDelegate:nil onViewController:self];
            }
        });
    }];
}

- (IBAction)submitAction:(id)sender{
    
    if (activeTextField != nil) {
        [activeTextField resignFirstResponder];
        activeTextField  = nil;
    }
    if (_emailIdField.text.length > 0) {
        [[ProgressHUD sharedProgressHUD] showActivityIndicatorOnView:self.view];
        NSMutableDictionary *mainDict = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *headersDict = [[NSMutableDictionary alloc] init];
        [headersDict setObject:@"Mobile" forKey:@"requestedFrom"];
        [headersDict setObject:[appDelegate getStringFromDate:[NSDate date] withFormat:@"yyyy-MM-dd hh:mm:ss"] forKey:@"requestedOn"];
        [headersDict setObject:[appDelegate getUUID] forKey:@"guid"];
        [headersDict setObject:[appDelegate currentLocation] forKey:@"geoLocation"];
        [mainDict setObject:headersDict forKey:@"header"];
        
        NSMutableDictionary *bodyDict = [[NSMutableDictionary alloc] init];
        [bodyDict setObject:[_emailIdField.text lowercaseString] forKey:@"emailId"];
        
        [mainDict setObject:bodyDict forKey:@"body"];
        
        [ServiceModel makeRequestFor:ForgotPassword WithInputParams:[appDelegate getJsonFormatedStringFrom:mainDict] AndToken:[[NSUserDefaults standardUserDefaults] objectForKey:AccessToken] MakeHttpRequest:^(NSDictionary *response, NSError *error){
            dispatch_async(dispatch_get_main_queue(), ^{
                [[ProgressHUD sharedProgressHUD] removeHUD];
                if (!error) {
                    if ([[response objectForKey:@"body"] objectForKey:@"emailId"]) {
                        [[AlertMessage sharedAlert] showAlertWithMessage:@"Reset password link sent to your email. Please verify." withDelegate:self onViewController:self];
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }else if([[response objectForKey:@"statusCode"] isEqualToString:@"-1"]){
                        [[AlertMessage sharedAlert] showAlertWithMessage:@"Invalid user. Please enter valid email." withDelegate:nil onViewController:self];
                    }
                    NSLog(@" Response  : %@", response);
                }else{
                    NSLog(@" Error : %@", error.localizedDescription);
                }
                
            });
        }];
    }else{
        [[AlertMessage sharedAlert] showAlertWithMessage:@"Please enter email id" withDelegate:nil onViewController:self];
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

#pragma mark AlertMessageDelegateProtocol Methods
- (void)clickedOkButton{
    [self.navigationController popViewControllerAnimated:YES];
}
@end

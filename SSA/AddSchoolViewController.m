//
//  AddSchoolViewController.m
//  SSA
//
//  Created by Sunera on 4/30/17.
//  Copyright © 2017 surya. All rights reserved.
//

#import "AddSchoolViewController.h"
#import "Constants.h"
#import "ProgressHUD.h"
#import "ServiceModel.h"
#import "Parse.h"
#import "AppDelegate.h"
#import "AlertMessage.h"

@interface AddSchoolViewController ()
{
    UITextField *activeTextField;
    NSString *schoolName;
}
- (IBAction)addSchoolUIDNumberAction:(id)sender;
- (IBAction)confirmSchoolAction:(id)sender;

@end

@implementation AddSchoolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    [_UIDNumberField setDelegate:self];
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
    [activeTextField resignFirstResponder];
    if ([_UIDNumberField.text length] != 0) {
        [self fetchSchoolDetails];
    }
}

- (IBAction)confirmSchoolAction:(id)sender{
    // Need to show alert
    [self showConformationAlert];
}

/**
 * @Discussion Showing alert to confirm adding school action
 */
- (void)showConformationAlert{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Confirmation"
                                          message:@"Are you sure you want to confirm"
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yesAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Yes", @"Yes action")
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       [self confirmSchool];
                                   }];
    
    UIAlertAction *noAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"No", @"No action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   NSLog(@"No action");
                               }];
    
    [alertController addAction:yesAction];
    [alertController addAction:noAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
/**
 * @Discussion fetching school details from server
 */
- (void)fetchSchoolDetails{
    [[ProgressHUD sharedProgressHUD] showActivityIndicatorOnView:self.view];
    [ServiceModel makeGetRequestFor:AddSchool WithInputParams:[NSString stringWithFormat:@"userRef=%@&SchoolUniqueId=%@&requestedon=%@&requestedfrom=%@&guid=%@&parentUserRef=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"UserRef"],_UIDNumberField.text,[appDelegate getStringFromDate:[NSDate date] withFormat:@"dd-MM-yyyy%20hh:mm:ss"],@"Mobile",[appDelegate getUUID],[[NSUserDefaults standardUserDefaults] objectForKey:@"UserRef"]] MakeHttpRequest:^(NSDictionary *response, NSError *error){
        dispatch_async(dispatch_get_main_queue(), ^{
            [[ProgressHUD sharedProgressHUD] removeHUD];
            if (!error) {
                NSLog(@" Add School Response  : %@", response);
                if([response objectForKey:@"body"]){
                    [[AlertMessage sharedAlert] showAlertWithMessage:[[response objectForKey:@"body"] objectForKey:@"message"] withDelegate:nil onViewController:self];
                }else{
                    [self updateSchoolDetails:response];
                    [_addSchoolUIDNumberBackgroundview setHidden:true];
                    [_confirmSchoolBackgroundView setHidden:false];
                    [_confirmSchoolImageView setImage:[UIImage imageNamed:@"confirmSchool-black-Active.png"]];
                    [_addSchoolImageView setImage:[UIImage imageNamed:@"addSchool-black.png"]];
                }
                
            }else{
                NSLog(@" Error : %@", error.localizedDescription);
                [[AlertMessage sharedAlert] showAlertWithMessage:error.localizedDescription withDelegate:nil onViewController:self];
            }
            
        });
    }];
}

/**
 * @Discussion Displaying the school details fetched from the server for the school unique id
 * @Param schoolDict as NSDictionary Object
 */
- (void)updateSchoolDetails:(NSDictionary *)schoolDict{
    [_schoolNameLabel setText:[schoolDict objectForKey:@"SchoolName"]];
    [_schoolAddressLabel setText:[NSString stringWithFormat:@"City : %@ \nState : %@ \nPincode : %@ \nWebSite : %@",[schoolDict objectForKey:@"city"],[schoolDict objectForKey:@"state"],[schoolDict objectForKey:@"zip"],[schoolDict objectForKey:@"WebSite"]]];
}
/**
 * @Discussion confirm adding school against parent
 */
- (void)confirmSchool{
   
    [[ProgressHUD sharedProgressHUD] showActivityIndicatorOnView:self.view];
    NSMutableDictionary *mainDict = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *headersDict = [[NSMutableDictionary alloc] init];
    [headersDict setObject:@"Mobile" forKey:@"requestedfrom"];
    [headersDict setObject:[appDelegate getStringFromDate:[NSDate date] withFormat:@"yyyy-MM-dd%20hh:mm:ss"] forKey:@"requestedon"];
    [headersDict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"UserRef"] forKey:@"parentUserRef"];
    [headersDict setObject:[appDelegate getUUID] forKey:@"guid"];
    [mainDict setObject:headersDict forKey:@"header"];
    
    NSMutableDictionary *bodyDict = [[NSMutableDictionary alloc] init];
    [bodyDict setObject:@"" forKey:@"modifiedOn"];
    [bodyDict setObject:@"" forKey:@"modifiedBy"];
    [bodyDict setObject:@"Parent" forKey:@"createdBy"];
    [bodyDict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"UserRef"] forKey:@"parentUserRef"];
    [bodyDict setObject:_UIDNumberField.text forKey:@"SchoolUniqueId"];
    [bodyDict setObject:_schoolNameLabel.text forKey:@"SchoolName"];
    [bodyDict setObject:[appDelegate getStringFromDate:[NSDate date] withFormat:@"dd-MM-yyyy%20HH:MM:SS"] forKey:@"createdOn"];
    [bodyDict setObject:@"" forKey:@"ParentSchoolId"];
    
    NSMutableArray *bodyArray = [[NSMutableArray alloc] init];
    [bodyArray addObject:bodyDict];
    
    [mainDict setObject:bodyArray forKey:@"body"];
    
    [ServiceModel makeRequestFor:ConfirmSchool WithInputParams:[appDelegate getJsonFormatedStringFrom:mainDict] MakeHttpRequest:^(NSDictionary *response, NSError *error){
        dispatch_async(dispatch_get_main_queue(), ^{
            [[ProgressHUD sharedProgressHUD] removeHUD];
            if (!error) {
                if ([[response objectForKey:@"body"] objectForKey:@"message"]) {
                    
                    if ([self.addSchoolViewControllerDelegate respondsToSelector:@selector(didSchoolAdded)]) {
                        [self.addSchoolViewControllerDelegate didSchoolAdded];
                    }
                    if (self.isFromSchoolList) {
                        self.fromSchoolistPage = false;
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    
                    //NSLog(@" Message %@", [[response objectForKey:@"body"] objectForKey:@"message"]);
                }
                NSLog(@" Response  : %@", response);
            }else{
                NSLog(@" Error : %@", error.localizedDescription);
            }
            
        });
    }];
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

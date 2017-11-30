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
#import "SharedManager.h"

@interface AddSchoolViewController ()<AlertMessageDelegateProtocol>
{
    UITextField *activeTextField;
    NSString *schoolName;
    NSDictionary *schoolResponseDict;
    BOOL addSchoolStatus;
}
- (IBAction)addSchoolUIDNumberAction:(id)sender;
- (IBAction)confirmSchoolAction:(id)sender;
- (IBAction)showSchoolUIDNumberAction:(id)sender;

@end

@implementation AddSchoolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    addSchoolStatus  = false;
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
    [ServiceModel makeGetRequestFor:AddSchool WithInputParams:[NSString stringWithFormat:@"userRef=%@&SchoolUniqueId=%@&requestedon=%@&requestedfrom=%@&guid=%@&parentUserRef=%@&geolocation=%@",[[NSUserDefaults standardUserDefaults] objectForKey:UserRef],_UIDNumberField.text,[appDelegate getStringFromDate:[NSDate date] withFormat:@"dd-MM-yyyy%20hh:mm:ss"],@"Mobile",[appDelegate getUUID],[[NSUserDefaults standardUserDefaults] objectForKey:UserRef],[appDelegate currentLocation]] AndToken:[[NSUserDefaults standardUserDefaults] objectForKey:AccessToken] MakeHttpRequest:^(NSDictionary *response, NSError *error){
        dispatch_async(dispatch_get_main_queue(), ^{
            [[ProgressHUD sharedProgressHUD] removeHUD];
            if (!error) {
                NSLog(@" Add School Response  : %@", response);
                if([[response objectForKey:@"body"] objectForKey:@"message"]){
                    [[AlertMessage sharedAlert] showAlertWithMessage:[[response objectForKey:@"body"] objectForKey:@"message"] withDelegate:nil onViewController:self];
                }else{
                    [self updateSchoolDetails:[response objectForKey:@"body"]];
                    [_addSchoolUIDNumberBackgroundview setHidden:true];
                    [_confirmSchoolBackgroundView setHidden:false];
                    [_confirmSchoolImageView setImage:[UIImage imageNamed:@"confirmSchool-black-Active.png"]];
                    [_addSchoolImageView setImage:[UIImage imageNamed:@"addSchool-black.png"]];
                }
                
            }else{
                if ([error.localizedDescription isEqualToString:TokenExpiredString]) {
                    [[AlertMessage sharedAlert] showAlertWithMessage:@"Session expired. Please login once again." withDelegate:self onViewController:self];
                }else{
                    [[AlertMessage sharedAlert] showAlertWithMessage:error.localizedDescription withDelegate:nil onViewController:self];
                }
                NSLog(@" Error : %@", error.localizedDescription);
            }
            
        });
    }];
}

/**
 * @Discussion Displaying the school details fetched from the server for the school unique id
 * @Param schoolDict as NSDictionary Object
 */
- (void)updateSchoolDetails:(NSDictionary *)schoolDict{
    schoolResponseDict = schoolDict;
    [_schoolNameLabel setText:[schoolDict objectForKey:@"SchoolName"]];
    [_uidLabel setText:[schoolDict objectForKey:@"SchoolUniqueId"]];
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
    [headersDict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:UserRef] forKey:@"parentUserRef"];
    [headersDict setObject:[appDelegate getUUID] forKey:@"guid"];
    [headersDict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:UserRef] forKey:@"userRef"];
    [mainDict setObject:headersDict forKey:@"header"];
    
    NSMutableDictionary *bodyDict = [[NSMutableDictionary alloc] init];
    [bodyDict setObject:@"" forKey:@"modifiedOn"];
    [bodyDict setObject:@"" forKey:@"modifiedBy"];
    [bodyDict setObject:@"Parent" forKey:@"createdBy"];
    [bodyDict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:UserRef] forKey:@"parentUserRef"];
    [bodyDict setObject:_UIDNumberField.text forKey:@"SchoolUniqueId"];
    [bodyDict setObject:_schoolNameLabel.text forKey:@"SchoolName"];
    [bodyDict setObject:[appDelegate getStringFromDate:[NSDate date] withFormat:@"dd-MM-yyyy%20HH:MM:SS"] forKey:@"createdOn"];
    [bodyDict setObject:@"" forKey:@"ParentSchoolId"];
    [bodyDict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:UserRef] forKey:@"userRef"];
    [bodyDict setObject:[schoolResponseDict objectForKey:@"city"] forKey:@"city"];
    [bodyDict setObject:[schoolResponseDict objectForKey:@"state"] forKey:@"state"];
    [bodyDict setObject:[schoolResponseDict objectForKey:@"FirstName"] forKey:@"FirstName"];
    [bodyDict setObject:[schoolResponseDict objectForKey:@"LastName"] forKey:@"LastName"];
    [bodyDict setObject:[schoolResponseDict objectForKey:@"Address"] forKey:@"Address"];
    [bodyDict setObject:[schoolResponseDict objectForKey:@"title"] forKey:@"title"];
    [bodyDict setObject:[schoolResponseDict objectForKey:@"EmailId"] forKey:@"EmailId"];
    [bodyDict setObject:[schoolResponseDict objectForKey:@"zip"] forKey:@"zip"];
    
    //NSMutableArray *bodyArray = [[NSMutableArray alloc] init];
    //[bodyArray addObject:bodyDict];
    
    [mainDict setObject:bodyDict forKey:@"body"];
    
    [ServiceModel makeRequestFor:ConfirmSchool WithInputParams:[appDelegate getJsonFormatedStringFrom:mainDict] AndToken:[[NSUserDefaults standardUserDefaults] objectForKey:AccessToken] MakeHttpRequest:^(NSDictionary *response, NSError *error){
        dispatch_async(dispatch_get_main_queue(), ^{
            [[ProgressHUD sharedProgressHUD] removeHUD];
            if (!error) {
                if ([[response objectForKey:@"body"] objectForKey:@"message"]) {
                    addSchoolStatus = true;
                    [self showAddSchoolUIDView];
                    [[AlertMessage sharedAlert] showAlertWithMessage:@"School added scucessfully" withDelegate:self onViewController:self];
                    
                    //NSLog(@" Message %@", [[response objectForKey:@"body"] objectForKey:@"message"]);
                }
                NSLog(@" Response  : %@", response);
            }else{
                if ([error.localizedDescription isEqualToString:TokenExpiredString]) {
                    [[AlertMessage sharedAlert] showAlertWithMessage:@"Session expired. Please login once again." withDelegate:self onViewController:self];
                }else{
                    [[AlertMessage sharedAlert] showAlertWithMessage:error.localizedDescription withDelegate:nil onViewController:self];
                }
                NSLog(@" Error : %@", error.localizedDescription);
            }
            
        });
    }];
}

- (IBAction)showSchoolUIDNumberAction:(id)sender{
    [self showAddSchoolUIDView];
}

/**
 *@discussion Showing add school unique id view to add new school
 */
- (void)showAddSchoolUIDView{
    [_addSchoolUIDNumberBackgroundview setHidden:false];
    [_confirmSchoolBackgroundView setHidden:true];
    [_confirmSchoolImageView setImage:[UIImage imageNamed:@"confirmSchool-black.png"]];
    [_addSchoolImageView setImage:[UIImage imageNamed:@"addSchool-black-Active.png"]];
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

#pragma mark AlertMessageDelegateProtocol methods
- (void)clickedOkButton{
    if(addSchoolStatus){
        if ([self.addSchoolViewControllerDelegate respondsToSelector:@selector(didSchoolAdded)]) {
            [self.addSchoolViewControllerDelegate didSchoolAdded];
        }
        if (self.isFromSchoolList) {
            self.fromSchoolistPage = false;
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        [[SharedManager sharedManager] logoutTheUser];
        [[SharedManager sharedManager] showLoginScreen];
    }
    
}
@end

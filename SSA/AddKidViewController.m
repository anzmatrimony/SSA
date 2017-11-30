//
//  AddKidViewController.m
//  SSA
//
//  Created by Sunera on 5/1/17.
//  Copyright © 2017 surya. All rights reserved.
//

#import "AddKidViewController.h"
#import "Constants.h"
#import "ProgressHUD.h"
#import "ServiceModel.h"
#import "Parse.h"
#import "AppDelegate.h"
#import "AlertMessage.h"
#import "ObjectManager.h"
#import "SharedManager.h"
#import "Firebase.h"

@interface AddKidViewController ()<AlertMessageDelegateProtocol>{
    UITextField *activeTextField;
    NSString *selectedSchool,*selectedClass,*selectedSection,*selectedRelation,*selectedKidImageId;
    NSArray *sectionsListArray,*relationShipListArray;
    NSMutableArray *schoolsListArray,*classListArray;
    BOOL addKidStatus;
}

@property (nonatomic, weak) IBOutlet UITextField *firstNameField,*lastNameField;
@property (nonatomic, weak) IBOutlet UIView *schoolBackgroundview,*classBackgroundView,*relationsShipBackgroundView,*chooseImageBackgroundView,*pickerViewBackgroundView;
@property (nonatomic, weak) IBOutlet UIImageView *addKidImageView;
@property (nonatomic, weak) IBOutlet UIPickerView *pickerView;
@property (nonatomic, weak) IBOutlet UIButton *schoolButton,*classButton,*relationButton;
@property (nonatomic, weak) IBOutlet UILabel *kidImagePathLabel;
- (IBAction)dropDownSelectionAction:(id)sender;


- (IBAction)submitAction:(id)sender;
- (IBAction)doneAction:(id)sender;
- (IBAction)browseImageAction:(id)sender;

@end

@implementation AddKidViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    addKidStatus  = false;
    appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate initializeLocationManager];
    schoolsListArray = [[NSMutableArray alloc] init];
    classListArray = [[NSMutableArray alloc] init];
    selectedKidImageId = 0;
    
    //classListArray = [[NSArray alloc] initWithObjects:@"LKG",@"UKG",@"FIRST CLASS",@"SECOND CLASS",@"THIRD CLASS",@"FOURTH CLASS",@"FIFTH CLASS",@"SIXTH CLASS",@"SEVENTH CLASS",@"EIGTH CLASS",@"NINTH CLASS", @"TENTH CLASS", nil];
    sectionsListArray = [[NSArray alloc] initWithObjects:@"SECTION-A",@"SECTION-B",@"SECTION-C",@"SECTION-D", nil];
    relationShipListArray = [[NSArray alloc] initWithObjects:@"Father",@"Mother", nil];
    
    [_addKidImageView.layer setCornerRadius:20];
    [_addKidImageView.layer setMasksToBounds:true];
    
    [self applyDesignToView:_firstNameField];
    [self applyDesignToView:_lastNameField];
    
    [self applyDesignToView:_classBackgroundView];
    //[self applyDesignToView:_sectionBackgroundView];
    [self applyDesignToView:_relationsShipBackgroundView];
    [self applyDesignToView:_chooseImageBackgroundView];
    [self applyDesignToView:_schoolBackgroundview];
    
    if (self.isFromSchoolPage) {
        [schoolsListArray addObject:self.selectedSchool];
        self.title = self.selectedSchool.SchoolName;
        [self updateSelectedSchool:[schoolsListArray objectAtIndex:0]];
    }
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

/**
 * Fetching schools list added by parent
 */
- (void)fetchSchoolsList{
    [[ProgressHUD sharedProgressHUD] showActivityIndicatorOnView:self.view];
    [ServiceModel makeGetRequestFor:SchoolsList WithInputParams:[NSString stringWithFormat:@"userRef=%@&requestedon=%@&requestedfrom=%@&guid=%@&parentUserRef=%@&geolocation=%@",[[NSUserDefaults standardUserDefaults] objectForKey:UserRef],[appDelegate getStringFromDate:[NSDate date] withFormat:@"dd-MM-yyyy%20hh:mm:ss"],@"Mobile",[appDelegate getUUID],[[NSUserDefaults standardUserDefaults] objectForKey:UserRef], [appDelegate currentLocation]]  AndToken:[[NSUserDefaults standardUserDefaults] objectForKey:AccessToken] MakeHttpRequest:^(NSDictionary *response, NSError *error){
        dispatch_async(dispatch_get_main_queue(), ^{
            [[ProgressHUD sharedProgressHUD] removeHUD];
            if (!error) {
                NSLog(@" Response  : %@", response);
                schoolsListArray = [[[Parse sharedParse] parseSchoolsListResponse:[response objectForKey:@"body"]] mutableCopy];
                
                SCHOOL_MODEL *school = [[SCHOOL_MODEL alloc] init];
                
                school.SchoolUniqueId = @"-1";
                school.SchoolName = @"Select School";
                
                [schoolsListArray insertObject:school atIndex:0];
                
                if (schoolsListArray.count == 1) {
                    [[AlertMessage sharedAlert] showAlertWithMessage:@"Please register atleast one school to add kid" withDelegate:nil onViewController:self];
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
 * Fetching schools list added by parent
 */
- (void)fetchClassesListFortheSelectedSchool{
    [[ProgressHUD sharedProgressHUD] showActivityIndicatorOnView:self.view];
    [ServiceModel makeGetRequestFor:ClassesListForSchool WithInputParams:[NSString stringWithFormat:@"uid=%@",selectedSchool]  AndToken:[[NSUserDefaults standardUserDefaults] objectForKey:AccessToken] MakeHttpRequest:^(NSDictionary *response, NSError *error){
        dispatch_async(dispatch_get_main_queue(), ^{
            [[ProgressHUD sharedProgressHUD] removeHUD];
            if (!error) {
                NSLog(@" Response  : %@", response);
                [classListArray removeAllObjects];
                classListArray = [[[Parse sharedParse] parseClassesListResponse:response] mutableCopy];
                
                NSDictionary *classDict = @{@"Class" : @"Select Class"};
                [classListArray insertObject:classDict atIndex:0];
                
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
 * @Discussion adding kid to parent
 **/
- (void)addKid{
    {
        NSMutableDictionary *mainDict = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *headersDict = [[NSMutableDictionary alloc] init];
        [headersDict setObject:@"Mobile" forKey:@"requestedfrom"];
        [headersDict setObject:[appDelegate getUUID] forKey:@"guid"];
        [headersDict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:UserRef] forKey:@"userRef"];
        [headersDict setObject:[appDelegate currentLocation] forKey:@"geolocation"];
        [mainDict setObject:headersDict forKey:@"header"];
        
        NSMutableDictionary *bodyDict = [[NSMutableDictionary alloc] init];
        [bodyDict setObject:selectedClass forKey:@"classe"];
        [bodyDict setObject:_firstNameField.text forKey:@"firstName"];
        [bodyDict setObject:_lastNameField.text forKey:@"lastName"];
        //[bodyDict setObject:[[selectedSection componentsSeparatedByString:@"-"] objectAtIndex:1] forKey:@"section"];
        [bodyDict setObject:@"NA" forKey:@"section"];
        [bodyDict setObject:[[_schoolButton titleLabel] text] forKey:@"SchoolName"];
        [bodyDict setObject:selectedSchool forKey:@"SchoolUniqueId"];
        [bodyDict setObject:@"Pending" forKey:@"kidstatus"];
        [bodyDict setObject:selectedRelation forKey:@"createdBy"];
        [bodyDict setObject:[appDelegate getStringFromDate:[NSDate date] withFormat:@"dd-MM-yyyy%20HH:MM:SS"] forKey:@"createdOn"];
        [bodyDict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:UserRef] forKey:@"parentUserRef"];
        [bodyDict setObject:selectedKidImageId forKey:@"Image"];
        
        [mainDict setObject:bodyDict forKey:@"body"];
        [[ProgressHUD sharedProgressHUD] showActivityIndicatorOnView:self.view];
        
        [ServiceModel makeRequestFor:KidRegistration WithInputParams:[appDelegate getJsonFormatedStringFrom:mainDict] AndToken:[[NSUserDefaults standardUserDefaults] objectForKey:AccessToken] MakeHttpRequest:^(NSDictionary *response, NSError *error){
            dispatch_async(dispatch_get_main_queue(), ^{
                [[ProgressHUD sharedProgressHUD] removeHUD];
                if (!error) {
                    if ([[response objectForKey:@"body"] objectForKey:@"smessage"]) {
                        
                        [_firstNameField setText:@""];
                        [_lastNameField setText:@""];
                        [_schoolButton setTitle:@"" forState:UIControlStateNormal];
                        [_classButton setTitle:@"" forState:UIControlStateNormal];
                        [_relationButton setTitle:@"" forState:UIControlStateNormal];
                        [_kidImagePathLabel setText:@""];
                        
                        selectedSchool = nil;
                        selectedRelation = nil;
                        selectedKidImageId = nil;
                        selectedClass = nil;
                        
                        addKidStatus = true;
                        [[AlertMessage sharedAlert] showAlertWithMessage:[[response objectForKey:@"body"] objectForKey:@"smessage"] withDelegate:self onViewController:self];
                        return ;
                    }
                    [self moveToPreviousScreen];
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
}

- (void)updateSelectedImagePathWith:(NSDictionary *)dict{
    [self.kidImagePathLabel setText:[dict objectForKey:@"ImageName"]];
    selectedKidImageId = [dict objectForKey:@"ImageId"];
}

- (void)moveToPreviousScreen{
    addKidStatus = true;
    [[AlertMessage sharedAlert] showAlertWithMessage:@"Kid added successfully" withDelegate:self onViewController:self];
    
}
- (IBAction)dropDownSelectionAction:(id)sender{
    [activeTextField resignFirstResponder];
    [_pickerView setTag:[sender tag]];
    [_pickerViewBackgroundView setHidden:false];
    [_pickerView reloadAllComponents];
}
- (IBAction)submitAction:(id)sender{
    if ([self doValidation]) {
        [self addKid];
    }
}

- (IBAction)doneAction:(id)sender{
    [_pickerViewBackgroundView setHidden:true];
    [activeTextField resignFirstResponder];
    if ([_pickerView tag] == 100 && classListArray.count == 0) { // checking is school selected or not to fetch the classes for the selected school
        [self fetchClassesListFortheSelectedSchool];
    }
}

- (IBAction)browseImageAction:(id)sender{
    KidsPhotosViewController *kidsPhotosViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"KidsPhotosViewController"];
    [kidsPhotosViewController setKidsPhotosViewControllerDelegate:self];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:kidsPhotosViewController];
    [self presentViewController:navController animated:YES completion:nil];
}
/**
 * @Discussion Validating user inputs
 * @Return boolean value
 **/
- (BOOL)doValidation{
    NSString *message = nil;
    if (_firstNameField.text.length == 0) {
        message = @"Please enter first name";
    }else if(_lastNameField.text.length == 0){
        message = @"Please enter last name";
    }else if(selectedSchool == nil || [selectedSchool isEqualToString:@"-1"]){
        message = @"Please select school";
    }else if(selectedClass == nil || [selectedClass isEqualToString:@"Select Class"]){
        message = @"Please select class";
    }else if(selectedRelation == nil){
        message = @"Please select relation";
    }
    if (message != nil && message.length > 0) {
        [[AlertMessage sharedAlert] showAlertWithMessage:message withDelegate:nil onViewController:self];
        return false;
    }
    
    return true;
}
#pragma mark - UITextField Delegate Methods
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [_pickerViewBackgroundView setHidden:true];
    activeTextField = textField;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    activeTextField = nil;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return true;
}

#pragma mark UIPickerView Delegate Methods
// The number of columns of data
- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch ([pickerView tag]) {
        case 100:
            if (schoolsListArray.count > 0) {
                return schoolsListArray.count;
            }
            return 0;
            break;
        case 200:
            return classListArray.count;
            break;
        case 300:
            return sectionsListArray.count;
            break;
        case 400:
            return relationShipListArray.count;
            break;
            
        default:
            return 0;
            break;
    }
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title;
    SCHOOL_MODEL *school;
    switch ([pickerView tag]) {
        case 100:
            school = [schoolsListArray objectAtIndex:row];
            title = school.SchoolName;
            break;
        case 200:
            title = [[classListArray objectAtIndex:row] objectForKey:@"Class"];
            break;
        case 300:
            title = [sectionsListArray objectAtIndex:row];
            break;
        case 400:
            title = [relationShipListArray objectAtIndex:row];
            break;
            
        default:
            break;
    }
    
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSString *title;
    switch ([pickerView tag]) {
        case 100:
            if (schoolsListArray.count > 0) {
                [self updateSelectedSchool:[schoolsListArray objectAtIndex:row]];
            }
            
            break;
        case 200:
            selectedClass = [[classListArray objectAtIndex:row] objectForKey:@"Class"];
            [_classButton setTitle:selectedClass forState:UIControlStateNormal];
            break;
        case 300:
            selectedSection = [sectionsListArray objectAtIndex:row] ;
            //[_sectionButton setTitle:selectedSection forState:UIControlStateNormal];
            break;
        case 400:
            selectedRelation = [relationShipListArray objectAtIndex:row];
            [_relationButton setTitle:selectedRelation forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
}

- (void)updateSelectedSchool:(SCHOOL_MODEL *)schoolModel{
    selectedSchool = schoolModel.SchoolUniqueId;
    [_schoolButton setTitle:schoolModel.SchoolName forState:UIControlStateNormal];
    [self fetchClassesListFortheSelectedSchool];
    selectedClass = nil;
    [_classButton setTitle:@"Please select class" forState:UIControlStateNormal];
}

#pragma mark AlertMessageDelegateProtocol methods
- (void)clickedOkButton{
    if (addKidStatus) {
        if (self.fromSchoolPage) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            if ([self.addKidViewControllerDelegate respondsToSelector:@selector(didKidAddedWithKidName:AndSchoolName:)]) {
                [self.addKidViewControllerDelegate didKidAddedWithKidName:[NSString stringWithFormat:@"%@ %@",_firstNameField.text,_lastNameField.text] AndSchoolName:[[_schoolButton titleLabel] text]];
            }
            
            if ([self isFromKidsListPage]) {
                self.fromKidsListPage = false;
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        
    }else{
        [[SharedManager sharedManager] logoutTheUser];
        [[SharedManager sharedManager] showLoginScreen];
    }
    
}

#pragma -mark KidsPhotosViewControllerProtocol methods
- (void)didDismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didSelectKidImage:(NSDictionary *)selectedKidImageDict{
    [self didDismiss];
    [self updateSelectedImagePathWith:selectedKidImageDict];
}
@end

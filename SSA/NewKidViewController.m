//
//  NewKidViewController.m
//  SSA
//
//  Created by Sunera on 5/15/17.
//  Copyright © 2017 surya. All rights reserved.
//

#import "NewKidViewController.h"
#import "Constants.h"
#import "ProgressHUD.h"
#import "ServiceModel.h"
#import "Parse.h"
#import "AppDelegate.h"
#import "AlertMessage.h"
#import "ObjectManager.h"

@interface NewKidViewController (){
    UITextField *activeTextField;
    NSString *selectedSchool,*selectedClass,*selectedSection,*selectedRelation;
    NSArray *classListArray,*sectionsListArray,*relationShipListArray;
    NSMutableArray *schoolsListArray;
}

@property (nonatomic, weak) IBOutlet UITextField *firstNameField,*lastNameField;
@property (nonatomic, weak) IBOutlet UIView *schoolBackgroundview,*classBackgroundView,*sectionBackgroundView,*relationsShipBackgroundView,*chooseImageBackgroundView,*pickerViewBackgroundView;
@property (nonatomic, weak) IBOutlet UIImageView *addKidImageView;
@property (nonatomic, weak) IBOutlet UIPickerView *pickerView;
@property (nonatomic, weak) IBOutlet UIButton *schoolButton,*classButton,*sectionButton,*relationButton;
- (IBAction)dropDownSelectionAction:(id)sender;


- (IBAction)submitAction:(id)sender;
- (IBAction)doneAction:(id)sender;

@end

@implementation NewKidViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate initializeLocationManager];
    schoolsListArray = [[NSMutableArray alloc] init];
    [self fetchSchoolsList];
    
    classListArray = [[NSArray alloc] initWithObjects:@"UKG",@"LKG",@"First Class",@"Second Class",@"Third Class",@"Fourth Class",@"Fifth Class", nil];
    sectionsListArray = [[NSArray alloc] initWithObjects:@"Section1",@"Section2",@"Section3", nil];
    relationShipListArray = [[NSArray alloc] initWithObjects:@"Father",@"Mother", nil];
    
    [_addKidImageView.layer setCornerRadius:20];
    [_addKidImageView.layer setMasksToBounds:true];
    
    [self applyDesignToView:_firstNameField];
    [self applyDesignToView:_lastNameField];
    
    [self applyDesignToView:_classBackgroundView];
    [self applyDesignToView:_sectionBackgroundView];
    [self applyDesignToView:_relationsShipBackgroundView];
    [self applyDesignToView:_chooseImageBackgroundView];
    [self applyDesignToView:_schoolBackgroundview];
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
    [ServiceModel makeGetRequestFor:SchoolsList WithInputParams:[NSString stringWithFormat:@"userRef=%@&requestedon=%@&requestedfrom=%@&guid=%@&parentUserRef=%@",[[NSUserDefaults standardUserDefaults] objectForKey:UserRef],[appDelegate getStringFromDate:[NSDate date] withFormat:@"dd-MM-yyyy%20hh:mm:ss"],@"Mobile",[appDelegate getUUID],[[NSUserDefaults standardUserDefaults] objectForKey:UserRef]] AndToken:[[NSUserDefaults standardUserDefaults] objectForKey:AccessToken] MakeHttpRequest:^(NSDictionary *response, NSError *error){
        dispatch_async(dispatch_get_main_queue(), ^{
            [[ProgressHUD sharedProgressHUD] removeHUD];
            if (!error) {
                NSLog(@" Response  : %@", response);
                schoolsListArray = (NSMutableArray *)[[Parse sharedParse] parseSchoolsListResponse:[response objectForKey:@"body"]];
                if (schoolsListArray.count == 0) {
                    [[AlertMessage sharedAlert] showAlertWithMessage:@"Please register atleast one school to add kid" withDelegate:nil onViewController:self];
                }
            }else{
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
        [bodyDict setObject:selectedSection forKey:@"section"];
        [bodyDict setObject:selectedSchool forKey:@"SchoolName"];
        [bodyDict setObject:selectedSchool forKey:@"SchoolUniqueId"];
        [bodyDict setObject:@"Pending" forKey:@"kidstatus"];
        [bodyDict setObject:selectedRelation forKey:@"createdBy"];
        [bodyDict setObject:[appDelegate getStringFromDate:[NSDate date] withFormat:@"dd-MM-yyyy%20HH:MM:SS"] forKey:@"createdOn"];
        [bodyDict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:UserRef] forKey:@"parentUserRef"];
        
        [mainDict setObject:bodyDict forKey:@"body"];
        [[ProgressHUD sharedProgressHUD] showActivityIndicatorOnView:self.view];
        
        [ServiceModel makeRequestFor:KidRegistration WithInputParams:[appDelegate getJsonFormatedStringFrom:mainDict] AndToken:[[NSUserDefaults standardUserDefaults] objectForKey:AccessToken] MakeHttpRequest:^(NSDictionary *response, NSError *error){
            dispatch_async(dispatch_get_main_queue(), ^{
                [[ProgressHUD sharedProgressHUD] removeHUD];
                if (!error) {
                    [self moveToPreviousScreen];
                }else{
                    NSLog(@" Error : %@", error.localizedDescription);
                }
                
            });
        }];
        
    }
}

- (void)moveToPreviousScreen{
    if ([self.addKidViewControllerDelegate respondsToSelector:@selector(didKidAdded)]) {
        [self.addKidViewControllerDelegate didKidAdded];
    }
    
    if ([self isFromKidsListPage]) {
        self.fromKidsListPage = false;
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (IBAction)dropDownSelectionAction:(id)sender{
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
}

/**
 * @Discussion Validating user inputs
 * @Return boolean value
 **/
- (BOOL)doValidation{
    if (_firstNameField.text.length == 0 || _lastNameField.text.length == 0 || selectedSchool == nil || selectedClass == nil || selectedSection == nil || selectedRelation == nil) {
        [[AlertMessage sharedAlert] showAlertWithMessage:@"Please fill all the fields" withDelegate:nil onViewController:self];
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
            return schoolsListArray.count;
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
    switch ([pickerView tag]) {
        case 100:
            title = [schoolsListArray objectAtIndex:row];
            break;
        case 200:
            title = [classListArray objectAtIndex:row];
            break;
        case 300:
            title = [schoolsListArray objectAtIndex:row];
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
            [self updateSelectedSchool:[schoolsListArray objectAtIndex:row]];
            break;
        case 200:
            selectedClass = [classListArray objectAtIndex:row];
            [_classButton setTitle:selectedClass forState:UIControlStateNormal];
            break;
        case 300:
            selectedSection = [schoolsListArray objectAtIndex:row];
            [_sectionButton setTitle:selectedSection forState:UIControlStateNormal];
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
}
@end

//
//  RegisterViewController.m
//  SSA
//
//  Created by Sunera on 4/30/17.
//  Copyright © 2017 surya. All rights reserved.
//

#import "RegisterViewController.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "AlertMessage.h"
#import "ProgressHUD.h"
#import "ServiceModel.h"
#import "Firebase.h"


@interface RegisterViewController ()<AlertMessageDelegateProtocol>{
    UITextField *activeTextField;
    BOOL isAgreedToTermsAndConditions;
    BOOL isGenderMale;
    BOOL isEmailValidated;
}

@property (nonatomic, weak) IBOutlet UITextField *firstNameField,*lastNameField,*emailField,*passwordFiedl,*confirmPasswordField,*phoneNumberField;

@property (nonatomic, weak) IBOutlet UIView *agreeTextContainerView,*genderBackgroundView;
@property (nonatomic, weak) IBOutlet UIButton *termsAndConditionsCheckBoxButton,*maleCheckBoxButton,*femaleCheckBoxButton;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *contentView;

- (IBAction)registerAction:(id)sender;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    [self.scrollView setContentSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width - 32, 660)];
    
    [appDelegate initializeLocationManager];
    isAgreedToTermsAndConditions = false;
    isEmailValidated = false;
    
    // By default selecting Male option for gender
    isGenderMale = true;
    [self changeGenderSelectionWithFlag:isGenderMale];
    
    [_firstNameField setLeftView: [appDelegate leftViewForTextfiledWithImage:@"user.png" withCornerRadius:nil]];
    
    [_lastNameField setLeftView: [appDelegate leftViewForTextfiledWithImage:@"user.png" withCornerRadius:nil]];
    
    [_emailField setLeftView: [appDelegate leftViewForTextfiledWithImage:@"email.png" withCornerRadius:nil]];
    
    [_phoneNumberField setLeftView: [appDelegate leftViewForTextfiledWithImage:@"mobile.png" withCornerRadius:nil]];
    
    [_passwordFiedl setLeftView: [appDelegate leftViewForTextfiledWithImage:@"pswd.png" withCornerRadius:nil]];
    
    [_confirmPasswordField setLeftView: [appDelegate leftViewForTextfiledWithImage:@"confirm-pswd.png" withCornerRadius:nil]];
    
    [self applyDesignToTextField:_firstNameField];
    [self applyDesignToTextField:_lastNameField];
    [self applyDesignToTextField:_emailField];
    [self applyDesignToTextField:_passwordFiedl];
    [self applyDesignToTextField:_confirmPasswordField];
    [self applyDesignToTextField:_phoneNumberField];
    
    [_genderBackgroundView.layer setCornerRadius:0];
    [_genderBackgroundView.layer setBorderWidth:1];
    [_genderBackgroundView.layer setBorderColor:COLOR(189, 218, 225).CGColor];
    
    [self buildAgreeTextViewFromString:NSLocalizedString(@"I accept #<ts>Terms and Conditions# and #<pp>Privacy Policy#",
                                                         @"PLEASE NOTE: please translate \"Terms and Conditions\" and \"Privacy Policy\" as well, and leave the #<ts># and #<pp># around your translations just as in the English version of this message.")];
    [self getAccessToken];
    [self addToolBarOnTopOfKeyboard];
}

- (void)viewDidAppear:(BOOL)animated{
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)applyDesignToTextField:(UITextField *)textField{
    [textField.layer setCornerRadius:0];
    [textField.layer setBorderWidth:1];
    [textField.layer setBorderColor:COLOR(189, 218, 225).CGColor];
    [textField setBackgroundColor:COLOR(250, 254, 255)];
    textField.leftViewMode = UITextFieldViewModeAlways;
}

/*!
 * @discussion adding tool bar on top of the keybord to dismiss the keybord
 */
- (void)addToolBarOnTopOfKeyboard{
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyboard)],nil];
    [numberToolbar sizeToFit];
    _phoneNumberField.inputAccessoryView = numberToolbar;
}

- (void)dismissKeyboard{
    if (activeTextField == nil)
        return;
    [activeTextField resignFirstResponder];
}
/**
 * @Discussion updating user interface of gender based on user selection (True -> Male; False -> Female)
 * @Param flag as a boolean value (True -> Male; False -> Female)
 */
- (void)changeGenderSelectionWithFlag:(BOOL)flag{
    if (flag) { // Male
        [_maleCheckBoxButton setImage:[UIImage imageNamed:@"CheckMark.png"] forState:UIControlStateNormal];
        [_femaleCheckBoxButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }else{ // Female
        [_maleCheckBoxButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_femaleCheckBoxButton setImage:[UIImage imageNamed:@"CheckMark.png"] forState:UIControlStateNormal];
    }
}
- (void)buildAgreeTextViewFromString:(NSString *)localizedString
{
    // 1. Split the localized string on the # sign:
    NSArray *localizedStringPieces = [localizedString componentsSeparatedByString:@"#"];
    
    // 2. Loop through all the pieces:
    NSUInteger msgChunkCount = localizedStringPieces ? localizedStringPieces.count : 0;
    CGPoint wordLocation = CGPointMake(0.0, 0.0);
    for (NSUInteger i = 0; i < msgChunkCount; i++)
    {
        NSString *chunk = [localizedStringPieces objectAtIndex:i];
        if ([chunk isEqualToString:@""])
        {
            continue;     // skip this loop if the chunk is empty
        }
        
        // 3. Determine what type of word this is:
        BOOL isTermsOfServiceLink = [chunk hasPrefix:@"<ts>"];
        BOOL isPrivacyPolicyLink  = [chunk hasPrefix:@"<pp>"];
        BOOL isLink = (BOOL)(isTermsOfServiceLink || isPrivacyPolicyLink);
        
        // 4. Create label, styling dependent on whether it's a link:
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:12.0f];
        label.text = chunk;
        label.userInteractionEnabled = isLink;
        
        if (isLink)
        {
            label.textColor = COLOR(18, 103, 136);
            label.highlightedTextColor = [UIColor yellowColor];
            
            // 5. Set tap gesture for this clickable text:
            SEL selectorAction = isTermsOfServiceLink ? @selector(tapOnTermsOfServiceLink:) : @selector(tapOnPrivacyPolicyLink:);
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                         action:selectorAction];
            [label addGestureRecognizer:tapGesture];
            
            // Trim the markup characters from the label:
            if (isTermsOfServiceLink)
                label.text = [label.text stringByReplacingOccurrencesOfString:@"<ts>" withString:@""];
            if (isPrivacyPolicyLink)
                label.text = [label.text stringByReplacingOccurrencesOfString:@"<pp>" withString:@""];
        }
        else
        {
            label.textColor = [UIColor blackColor];
        }
        
        // 6. Lay out the labels so it forms a complete sentence again:
        
        // If this word doesn't fit at end of this line, then move it to the next
        // line and make sure any leading spaces are stripped off so it aligns nicely:
        
        [label sizeToFit];
        
        if (self.agreeTextContainerView.frame.size.width < wordLocation.x + label.bounds.size.width)
        {
            wordLocation.x = 0.0;                       // move this word all the way to the left...
            wordLocation.y += label.frame.size.height;  // ...on the next line
            
            // And trim of any leading white space:
            NSRange startingWhiteSpaceRange = [label.text rangeOfString:@"^\\s*"
                                                                options:NSRegularExpressionSearch];
            if (startingWhiteSpaceRange.location == 0)
            {
                label.text = [label.text stringByReplacingCharactersInRange:startingWhiteSpaceRange
                                                                 withString:@""];
                [label sizeToFit];
            }
        }
        
        // Set the location for this label:
        label.frame = CGRectMake(wordLocation.x,
                                 wordLocation.y,
                                 label.frame.size.width,
                                 label.frame.size.height);
        // Show this label:
        [self.agreeTextContainerView addSubview:label];
        
        // Update the horizontal position for the next word:
        wordLocation.x += label.frame.size.width;
    }
}

- (void)tapOnTermsOfServiceLink:(UITapGestureRecognizer *)tapGesture
{
    if (tapGesture.state == UIGestureRecognizerStateEnded)
    {
        NSLog(@"User tapped on the Terms of Service link");
    }
}


- (void)tapOnPrivacyPolicyLink:(UITapGestureRecognizer *)tapGesture
{
    if (tapGesture.state == UIGestureRecognizerStateEnded)
    {
        NSLog(@"User tapped on the Privacy Policy link");
    }
}

- (IBAction)registerAction:(id)sender{
    if ([self doValidation]) {
        //[self getAccessToken];
        [self registerParentWithToken:[[NSUserDefaults standardUserDefaults] objectForKey:AccessToken]];
    }
}

- (IBAction)termsAndConditionsCheckBoxAction:(id)sender{
    if (isAgreedToTermsAndConditions) {
        [_termsAndConditionsCheckBoxButton setImage:[UIImage imageNamed:@"check-box-empty.png"] forState:UIControlStateNormal];
    }else{
        [_termsAndConditionsCheckBoxButton setImage:[UIImage imageNamed:@"check-box.png"] forState:UIControlStateNormal];
    }
    isAgreedToTermsAndConditions = !isAgreedToTermsAndConditions;
}

- (IBAction)genderSelectionAction:(id)sender{
    if ([sender tag] == 100 || [sender tag] == 200) { // Male
        isGenderMale = true;
    }else if ([sender tag] == 300 || [sender tag] == 400){
        isGenderMale = false;
    }
    [self changeGenderSelectionWithFlag:isGenderMale];
}
// Validating user inputs
- (BOOL)doValidation{
    NSString *message = nil;
    if (_firstNameField.text.length == 0) {
        message = @"Please enter first name";
    }else if (_lastNameField.text.length == 0){
        message = @"Please enter last name";
    }else if (_emailField.text.length == 0){
        message = @"Please enter email";
    }else if (_passwordFiedl.text.length == 0){
        message = @"Please enter password";
    }else if (_confirmPasswordField.text.length == 0){
        message = @"Please enter confirm password";
    }else if(![self isValidPassword:_passwordFiedl.text]){
        message = PasswordInfoString;
    }else if (![_passwordFiedl.text isEqualToString:_confirmPasswordField.text]){
        message = @"Password and confirm password must be same";
    }else if (!isAgreedToTermsAndConditions) {
        message = @"Please accept terms of service and privacy policy";
    }else if(![self isValidEmail]){
        message = @"Please enter valid email address. Please use only Letters(a-z),numbers,@ and .(fullstop)";
    }else if(!isEmailValidated){
        message = @"EmailID already exist. Please try another";
    }
    
    if (message != nil && message.length > 0) {
        [[AlertMessage sharedAlert] showAlertWithMessage:message withDelegate:nil onViewController:self];
        return false;
    }
    return YES;
}

/*!
 * @discussion validating email address entered by the user
 * @return boolean value
 */
- (BOOL)isValidEmail{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:_emailField.text];
}

/*!
 * @dicussion validating password entered by the use (Password needs to have 1 small charector 1 upper charecter and 1 number)
 * @param password as NSString object
 * @return boolean value
 */
-(BOOL)isValidPassword:(NSString *)password
{
    NSLog(@"Password : %@",password);
    NSCharacterSet *upperCaseChars = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLKMNOPQRSTUVWXYZ"];
    NSCharacterSet *lowerCaseChars = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyz"];
    //NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    NSCharacterSet *specialCharecters = [NSCharacterSet characterSetWithCharactersInString:@"@#&*%^"];
    
    if ( [password length]<8 )
        return NO;  //too short
    NSRange range;
    range = [password rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet]];
    if ( !range.length )
        return NO;  // no letter
    range = [password rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]];
    if ( !range.length )
        return NO;  // no number;
    range = [password rangeOfCharacterFromSet:upperCaseChars];
    if ( !range.length )
        return NO;  // no uppercase letter;
    range = [password rangeOfCharacterFromSet:lowerCaseChars];
    if ( !range.length )
        return NO;  // no lowerCase Chars;
    range = [password rangeOfCharacterFromSet:specialCharecters];
    if (!range.length) {
        return NO; // no special charcter
    }
    return YES;
    
}

- (void)registerParentWithToken:(NSString *)token{
    
    [[ProgressHUD sharedProgressHUD] showActivityIndicatorOnView:self.view];
    NSMutableDictionary *mainDict = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *headersDict = [[NSMutableDictionary alloc] init];
    [headersDict setObject:@"Mobile" forKey:@"requestedfrom"];
    [headersDict setObject:[appDelegate getStringFromDate:[NSDate date] withFormat:@"yyyy-MM-dd hh:mm:ss"] forKey:@"requestedon"];
    [headersDict setObject:[NSString stringWithFormat:@"%@%@",[[_emailField.text componentsSeparatedByString:@"@"] objectAtIndex:0],TimeStamp] forKey:@"userRef"];
    [headersDict setObject:[appDelegate currentLocation] forKey:@"geolocation"];
    [mainDict setObject:headersDict forKey:@"header"];
    
    NSMutableDictionary *bodyDict = [[NSMutableDictionary alloc] init];
    [bodyDict setObject:[_emailField.text lowercaseString] forKey:@"userId"];
    [bodyDict setObject:_firstNameField.text forKey:@"firstName"];
    [bodyDict setObject:_lastNameField.text forKey:@"lastName"];
    [bodyDict setObject:_passwordFiedl.text forKey:@"password"];
    [bodyDict setObject:[_emailField.text lowercaseString] forKey:@"emailId"];
    
    if ([_phoneNumberField.text length] > 0) {
        [bodyDict setObject:_phoneNumberField.text forKey:@"phoneNumber"];
    }else{
        [bodyDict setObject:@"NA" forKey:@"phoneNumber"];
    }
    
    [bodyDict setObject:isGenderMale?@"Male":@"Female" forKey:@"Gender"];
    [mainDict setObject:bodyDict forKey:@"body"];
    
    [ServiceModel makeRequestFor:ParentRegistration WithInputParams:[appDelegate getJsonFormatedStringFrom:mainDict] AndToken:token MakeHttpRequest:^(NSDictionary *response, NSError *error){
        dispatch_async(dispatch_get_main_queue(), ^{
            [[ProgressHUD sharedProgressHUD] removeHUD];
            if (!error) {
                if ([[response objectForKey:@"body"] objectForKey:@"message"]) {
                    [self registerInFireBase];
                    NSLog(@" Message %@", [[response objectForKey:@"body"] objectForKey:@"message"]);
                    [[AlertMessage sharedAlert] showAlertWithMessage:@"Registration successfull" withDelegate:self onViewController:self];
                    //[self.navigationController popToRootViewControllerAnimated:YES];
                }
                NSLog(@" Response  : %@", response);
            }else{
                NSLog(@" Error : %@", error.localizedDescription);
            }
            
        });
    }];
}

/**
 *@discussion creating user in firebase
 */
- (void)registerInFireBase{
    [[FIRAuth auth] createUserWithEmail:_emailField.text password:_passwordFiedl.text completion:^(FIRUser *user, NSError *error){
        if (error == nil) {
            NSLog(@"User created successfully in firebase");
        }else{
            NSLog(@"Problem occured while creating user");
            NSLog(@" Error : %@ ",error.localizedDescription);
        }
    }];
}

/**77
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

/**
 *@discussion checking entered email address available or not
 */
- (void)checkEmailExistence{
    
    [[ProgressHUD sharedProgressHUD] showActivityIndicatorOnView:self.view];
    [ServiceModel makeGetRequestFor:ValidateEmail WithInputParams:[NSString stringWithFormat:@"requestedon=%@&requestedfrom=%@&guid=%@&emailID=%@&geolocation=%@",[appDelegate getStringFromDate:[NSDate date] withFormat:@"dd-MM-yyyy%20hh:mm:ss"],@"Mobile",[appDelegate getUUID],_emailField.text, [appDelegate currentLocation]] AndToken:[[NSUserDefaults standardUserDefaults] objectForKey:AccessToken] MakeHttpRequest:^(NSDictionary *response, NSError *error){
        dispatch_async(dispatch_get_main_queue(), ^{
            [[ProgressHUD sharedProgressHUD] removeHUD];
            if (!error) {
                NSLog(@"email validdatio response %@", response);
                if ([response objectForKey:@"result"]) {
                    isEmailValidated = false;
                    [[AlertMessage sharedAlert] showAlertWithMessage:@"Entered emailid already exist. Please try another valid email." withDelegate:nil onViewController:self];
                   
                }else{
                    isEmailValidated = true;
                }
                
            }else{
                [[AlertMessage sharedAlert] showAlertWithMessage:error.localizedDescription withDelegate:nil onViewController:self];
            }
        });
    }];

}
#pragma mark - UITextField Delegate Methods
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    activeTextField = textField;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 100) {
        [textField resignFirstResponder];
        //[self getAccessToken];
        [self checkEmailExistence];
    }
    if (textField.tag == 300) {
        if (_confirmPasswordField.text.length > 0 && ![self isValidPassword:_confirmPasswordField.text]) {
            [[AlertMessage sharedAlert] showAlertWithMessage:PasswordInfoString withDelegate:nil onViewController:self];
            return;
        }
        
        if (_confirmPasswordField.text.length > 0 ) {
            if(![_passwordFiedl.text isEqualToString:_confirmPasswordField.text]){
            [[AlertMessage sharedAlert] showAlertWithMessage:@"Password and confirm password must be same" withDelegate:nil onViewController:self];
            return;
            }
        }
    }
    
    if (textField.tag == 200) {
        
        if (_passwordFiedl.text.length > 0 && ![self isValidPassword:_passwordFiedl.text]) {
            [[AlertMessage sharedAlert] showAlertWithMessage:PasswordInfoString withDelegate:nil onViewController:self];
            return;
        }
        
        if (_confirmPasswordField.text.length > 0) {
            
            if (![_passwordFiedl.text isEqualToString:_confirmPasswordField.text]) {
                [[AlertMessage sharedAlert] showAlertWithMessage:@"Password and confirm password must be same" withDelegate:nil onViewController:self];
                return;
            }
        }
    }
    activeTextField = nil;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSCharacterSet *cs;
    NSString *filtered;
    if ([textField tag] == 4) {
        if(range.length + range.location > textField.text.length)
        {
            return NO;
        }
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return newLength <= 10;  // phone number field max length
    }if([textField tag] == 100){ // Email
        cs = [[NSCharacterSet characterSetWithCharactersInString:AcceptableCharectersForEmail] invertedSet];
        filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        if (![string isEqualToString:filtered]) {
            return NO;
        }
    }
    return true;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return true;
}

- (void)clickedOkButton
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}@end

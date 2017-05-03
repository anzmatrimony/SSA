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

@interface RegisterViewController (){
    UITextField *activeTextField;
    BOOL isAgreedToTermsAndConditions;
}

@property (nonatomic, weak) IBOutlet UITextField *firstNameField,*lastNameField,*emailField,*passwordFiedl,*confirmPasswordField;

@property (nonatomic, weak) IBOutlet UIView *agreeTextContainerView;
@property (nonatomic, weak) IBOutlet UIButton *termsAndConditionsCheckBoxButton;

- (IBAction)registerAction:(id)sender;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    isAgreedToTermsAndConditions = false;
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    [_firstNameField setLeftView: [appDelegate leftViewForTextfiledWithImage:@"user.png" withCornerRadius:nil]];
    
    [_lastNameField setLeftView: [appDelegate leftViewForTextfiledWithImage:@"user.png" withCornerRadius:nil]];
    
    [_emailField setLeftView: [appDelegate leftViewForTextfiledWithImage:@"email.png" withCornerRadius:nil]];
    
    [_passwordFiedl setLeftView: [appDelegate leftViewForTextfiledWithImage:@"pswd.png" withCornerRadius:nil]];
    
    [_confirmPasswordField setLeftView: [appDelegate leftViewForTextfiledWithImage:@"confirm-pswd.png" withCornerRadius:nil]];
    
    [self applyDesignToTextField:_firstNameField];
    [self applyDesignToTextField:_lastNameField];
    [self applyDesignToTextField:_emailField];
    [self applyDesignToTextField:_passwordFiedl];
    [self applyDesignToTextField:_confirmPasswordField];
    
    [self buildAgreeTextViewFromString:NSLocalizedString(@"I accept #<ts>Terms and Conditions# and #<pp>Privacy Policy#",
                                                         @"PLEASE NOTE: please translate \"Terms and Conditions\" and \"Privacy Policy\" as well, and leave the #<ts># and #<pp># around your translations just as in the English version of this message.")];
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
    
}

- (IBAction)termsAndConditionsCheckBoxAction:(id)sender{
    if (isAgreedToTermsAndConditions) {
        [_termsAndConditionsCheckBoxButton setImage:[UIImage imageNamed:@"black-check-box.png"] forState:UIControlStateNormal];
    }else{
        [_termsAndConditionsCheckBoxButton setImage:[UIImage imageNamed:@"check-box.png"] forState:UIControlStateNormal];
    }
    isAgreedToTermsAndConditions = !isAgreedToTermsAndConditions;
}
// Validating user inputs
- (BOOL)doValidation{
    if (_firstNameField.text.length == 0 || _lastNameField.text.length == 0 || _emailField.text.length == 0 || _passwordFiedl.text.length == 0 || _confirmPasswordField.text.length == 0) {
        [[AlertMessage sharedAlert] showAlertWithMessage:AlertTitle withDelegate:@"Please fill all the fields" onViewController:self];
        return NO;
    }else if (![_passwordFiedl.text isEqualToString:_confirmPasswordField.text]){
        [[AlertMessage sharedAlert] showAlertWithMessage:AlertTitle withDelegate:@"Password and confirm password must be same" onViewController:self];
        return NO;
    }if (!isAgreedToTermsAndConditions) {
        [[AlertMessage sharedAlert] showAlertWithMessage:AlertTitle withDelegate:@"Please accept terms of service and privacy policy" onViewController:self];
        return NO;
    }
    return YES;
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

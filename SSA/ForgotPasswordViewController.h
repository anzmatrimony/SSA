//
//  ForgotPasswordViewController.h
//  SSA
//
//  Created by Sunera on 7/17/17.
//  Copyright © 2017 surya. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AppDelegate;

@interface ForgotPasswordViewController : UIViewController
{
    AppDelegate *appDelegate;
}
@property (nonatomic, weak) IBOutlet UITextField *emailIdField;

@end

//
//  Constants.h
//  SSA
//
//  Created by Sunera on 4/30/17.
//  Copyright © 2017 surya. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#define TextFieldHeight  40

#define COLOR(R,G,B) [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:1.0]

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define AlertTitle @"SSA"

#define TimeStamp [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]]

#define BaseURL @""
#define ParentRegistration 1
#define SchoolRegistration 2
#define KidRegistration 3
#define SchoolsList 4
#define AddSchool 5
#define ConfirmSchool 6
#define KidsList 7

#endif /* Constants_h */

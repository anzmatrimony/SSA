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

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


#define COLOR(R,G,B) [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:1.0]

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define AlertTitle @"SSA"

#define TimeStamp [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]]

#define RememberMeStatus @"RememberMeStatus"
#define AccessToken @"AppAccessToken"
#define LoginStatus @"LoginStatus"
#define MPIN @"MPIN"
#define UserRef @"UserRef"
#define Role @"RoleType"
#define UserStatus @"UserStatus"
#define TokenExpiredString @"TokenExpired"
#define UserName @"UserName"
#define Password @"Password"
#define schoolUniqueId @"SchoolUniqueId"
#define TeacherName @"TeacherName"

#define IsTouchIdRequired @"TouchIdRequired"
#define BaseURL @""
#define ParentRegistration 1
#define SchoolRegistration 2
#define KidRegistration 3
#define SchoolsList 4
#define AddSchool 5
#define ConfirmSchool 6
#define KidsList 7
#define GetProfile 8
#define ValidateEmail 9
#define KidListForTeacher 10

#endif /* Constants_h */

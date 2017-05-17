//
//  ObjectManager.h
//  SSA
//
//  Created by Sunera on 5/12/17.
//  Copyright © 2017 surya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObjectManager : NSObject

@end

#pragma mark - SCHOOL
/** SCHOOL_MODEL properties */
@interface SCHOOL_MODEL : NSObject

@property (strong, nonatomic) NSString* modifiedOn;
@property (strong, nonatomic) NSString* modifiedBy;
@property (strong, nonatomic) NSString* createdBy;
@property (strong, nonatomic) NSString* parentUserRef;
@property (strong, nonatomic) NSString* SchoolUniqueId;
@property (strong, nonatomic) NSString* SchoolName;
@property (strong, nonatomic) NSString* createdOn;
@property (strong, nonatomic) NSString* ParentSchoolId;

@end

#pragma mark - KID
/** SCHOOL_MODEL properties */
@interface KID_MODEL : NSObject

@property (strong, nonatomic) NSString* kidStatus;
@property (strong, nonatomic) NSString* kidId;
@property (strong, nonatomic) NSString* kidClass;
@property (strong, nonatomic) NSString* modifiedBy;
@property (strong, nonatomic) NSString* schoolName;
@property (strong, nonatomic) NSString* createdOn;
@property (strong, nonatomic) NSString* Relationship;
@property (strong, nonatomic) NSString* lastName;
@property (strong, nonatomic) NSString* Section;
@property (strong, nonatomic) NSString* modifiedOn;
@property (strong, nonatomic) NSString* firstName;
@property (strong, nonatomic) NSString* Image;
@property (strong, nonatomic) NSString* parentUserRef;
@property (strong, nonatomic) NSString* SchoolUniqueId;
@property (strong, nonatomic) NSString* createdBy;

@end

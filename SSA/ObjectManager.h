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
@property (strong, nonatomic) NSString* SchoolImageUrl;

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
@property (strong, nonatomic) NSString* unreadMessagesCount;
@property (strong, nonatomic) NSMutableArray * activities;
@end

@interface KidActivitiesModel : NSObject

@property(nonatomic, strong) NSString *KidName;
@property(nonatomic, strong) NSString *SchoolUniqueId;
@property(nonatomic, strong) NSString *activityID;
@property(nonatomic, strong) NSString *activitysubject;
@property(nonatomic, strong) NSString *kiduserID;
@property(nonatomic, strong) NSString *rowid;
@property(nonatomic, strong) NSString *status;
@property(nonatomic, strong) NSString *statusupdateon;
@property(nonatomic, strong) NSString *teacheruserref;
@property(nonatomic, strong) NSString *templateID;
@property(nonatomic, strong) NSString *templatename;
@property(nonatomic, strong) NSString *userId;
@end



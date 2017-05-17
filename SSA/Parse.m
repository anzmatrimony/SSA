//
//  Parse.m
//  Facatail
//
//  Created by Sunera on 5/12/16.
//  Copyright © 2016 Facatil. All rights reserved.
//

#import "Parse.h"
#import "AppDelegate.h"
#import "ObjectManager.h"


@interface Parse(){
}

@end

@implementation Parse


static Parse *singleTonManager;
+ (Parse *)sharedParse{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!singleTonManager) {
            singleTonManager = [[[self class] alloc] init];
        }
    });
    
    return singleTonManager;
}

/**
 * @Discussion Parsing the schools list retrieved from the server
 * @Param responseArray as a NSArray Objcet
 * @Return NSArray object
 **/
- (NSArray *)parseSchoolsListResponse:(NSArray *)responseArray{
    if (![self checkArrayList:responseArray]) {
        return nil;
    }
    
    NSMutableArray *schoolsListArray = [[NSMutableArray alloc] init];
    for (NSDictionary *schoolDict in responseArray) {
        SCHOOL_MODEL *school = [[SCHOOL_MODEL alloc] init];
        school.modifiedOn = [self nullCheckForTheKey:@"modifiedOn" In:schoolDict] ? @"" : [schoolDict objectForKey:@"modifiedOn"];
        school.modifiedBy = [self nullCheckForTheKey:@"modifiedBy" In:schoolDict] ? @"" : [schoolDict objectForKey:@"modifiedBy"];
        school.createdBy = [self nullCheckForTheKey:@"createdBy" In:schoolDict] ? @"" : [schoolDict objectForKey:@"createdBy"];
        school.createdOn = [self nullCheckForTheKey:@"createdOn" In:schoolDict] ? @"" : [schoolDict objectForKey:@"createdOn"];
        school.parentUserRef = [self nullCheckForTheKey:@"parentUserRef" In:schoolDict] ? @"" : [schoolDict objectForKey:@"parentUserRef"];
        school.ParentSchoolId = [self nullCheckForTheKey:@"ParentSchoolId" In:schoolDict] ? @"" : [schoolDict objectForKey:@"ParentSchoolId"];
        school.SchoolUniqueId = [self nullCheckForTheKey:@"SchoolUniqueId" In:schoolDict] ? @"" : [schoolDict objectForKey:@"SchoolUniqueId"];
        school.SchoolName = [self nullCheckForTheKey:@"SchoolName" In:schoolDict] ? @"" : [schoolDict objectForKey:@"SchoolName"];
        
        [schoolsListArray addObject:school];
    }
    
    return schoolsListArray;
}


/**
 * @Discussion Parsing the schools list retrieved from the server
 * @Param responseArray as a NSArray Objcet
 * @Return NSArray object
 **/
- (NSArray *)parseKidsListResponse:(NSArray *)responseArray{
    if (![self checkArrayList:responseArray]) {
        return nil;
    }
    
    NSMutableArray *kidsListArray = [[NSMutableArray alloc] init];
    for (NSDictionary *kidDict in responseArray) {
        KID_MODEL *kid = [[KID_MODEL alloc] init];
        kid.firstName = [self nullCheckForTheKey:@"firstName" In:kidDict] ? @"" : [kidDict objectForKey:@"firstName"];
        kid.kidStatus = [self nullCheckForTheKey:@"kidStatus" In:kidDict] ? @"" : [kidDict objectForKey:@"kidStatus"];
        kid.kidId = [self nullCheckForTheKey:@"kidId" In:kidDict] ? @"" : [kidDict objectForKey:@"kidId"];
        kid.kidClass = [self nullCheckForTheKey:@"Class" In:kidDict] ? @"" : [kidDict objectForKey:@"Class"];
        kid.modifiedBy = [self nullCheckForTheKey:@"modifiedBy" In:kidDict] ? @"" : [kidDict objectForKey:@"modifiedBy"];
        kid.schoolName = [self nullCheckForTheKey:@"schoolName" In:kidDict] ? @"" : [kidDict objectForKey:@"schoolName"];
        kid.createdOn = [self nullCheckForTheKey:@"createdOn" In:kidDict] ? @"" : [kidDict objectForKey:@"createdOn"];
        kid.createdBy = [self nullCheckForTheKey:@"createdBy" In:kidDict] ? @"" : [kidDict objectForKey:@"createdBy"];
        kid.Relationship = [self nullCheckForTheKey:@"Relationship" In:kidDict] ? @"" : [kidDict objectForKey:@"Relationship"];
        kid.lastName = [self nullCheckForTheKey:@"lastName" In:kidDict] ? @"" : [kidDict objectForKey:@"lastName"];
        kid.Section = [self nullCheckForTheKey:@"Section" In:kidDict] ? @"" : [kidDict objectForKey:@"Section"];
        kid.modifiedOn = [self nullCheckForTheKey:@"modifiedOn" In:kidDict] ? @"" : [kidDict objectForKey:@"modifiedOn"];
        kid.Image = [self nullCheckForTheKey:@"Image" In:kidDict] ? @"" : [kidDict objectForKey:@"Image"];
        kid.parentUserRef = [self nullCheckForTheKey:@"parentUserRef" In:kidDict] ? @"" : [kidDict objectForKey:@"parentUserRef"];
        kid.SchoolUniqueId = [self nullCheckForTheKey:@"SchoolUniqueId" In:kidDict] ? @"" : [kidDict objectForKey:@"SchoolUniqueId"];
        
        [kidsListArray addObject:kid];
    }
    
    return kidsListArray;
}

/**
 * @Discussion Checking weather received object is an Array or not
 * @Param array as an NSArray object
 * @Return Boolean value
 **/
- (BOOL)checkArrayList:(NSArray *)array{
    if ([array isKindOfClass:[NSArray class]]) {
        return true;
    }
    return false;
}

/**
 * @discussion Checking for "Null" value for the key in the dictionary
 * @Param key as an NSString Object
 * @Param dict as a NSDictionary Object
 * @Return Boolean value
 **/
- (BOOL)nullCheckForTheKey:(NSString *)key In:(NSDictionary *)dict{
    if ([[dict objectForKey:key] isKindOfClass:[NSNull class]] || [[dict objectForKey:key] isEqual:[NSNull null]] || [dict objectForKey:key] == nil) {
        return true;
    }
    return false;
}
@end

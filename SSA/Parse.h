//
//  Parse.h
//  Facatail
//
//  Created by Sunera on 5/12/16.
//  Copyright © 2016 Facatil. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AppDelegate;

@interface Parse : NSObject{
    int indentValue;
    AppDelegate *appDelegate;
}

+(Parse *)sharedParse;

- (NSArray *)parseSchoolsListResponse:(NSArray *)responseArray;
- (NSArray *)parseKidsListResponse:(NSArray *)responseArray;
- (NSArray *)parseKidsListResponseForTeacherLogIn:(NSArray *)responseArray;
- (NSArray *)parseKidsActivities:(NSArray *)responseArray;

@end

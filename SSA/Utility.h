//
//  Utility.h
//  BarcodeScanner
//
//  Created by Surya Narayana Vennala on 11/10/14.
//  Copyright (c) 2014 Draconis Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject

+ (NSError *)showErrorWhenNetworkFailed;
+ (NSError *)showErrorWhenExceptionOccured;

+(BOOL) checkNetworkStatus;
@end


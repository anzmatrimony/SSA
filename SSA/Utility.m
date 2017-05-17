//
//  Utility.m
//  BarcodeScanner
//
//  Created by Surya Narayana Vennala on 11/10/14.
//  Copyright (c) 2014 Draconis Software. All rights reserved.
//
#import "Utility.h"
#import "Reachability.h"

@implementation Utility

+ (NSError *)showErrorWhenNetworkFailed{
    
    NSDictionary *dict;
    if (![self checkNetworkStatus])
        dict = @{NSLocalizedDescriptionKey: @"Please enable network connection"};
    else
        dict = @{NSLocalizedDescriptionKey: @"Problem Fetching Data. Please try again."};
    
    // NSDictionary *dict = @{NSLocalizedDescriptionKey: @"Oops !! something went wrong. Pls contact the admin."};
    
    NSError *error = [NSError errorWithDomain:@"Network Error" code:888 userInfo:dict];
    
    return error;
    
}

+ (NSError *)showErrorWhenExceptionOccured{
    NSDictionary *dict = @{NSLocalizedDescriptionKey: @"We are unable to fetch the data. Please try again. Regret the inconvenience."};
    NSError *error = [NSError errorWithDomain:@"Network Error" code:888 userInfo:dict];
    
    return error;
    
}

+(BOOL) checkNetworkStatus
{
    Reachability *internetReachable = [Reachability reachabilityForInternetConnection];
    //[internetReachable startNotifier];
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    switch (internetStatus)
    {
        case NotReachable:
        {
            return FALSE;
        }
        case ReachableViaWiFi:
        {
            return TRUE;
        }
        case ReachableViaWWAN:
        {
            return TRUE;
        }
    }
    return FALSE;
}

@end
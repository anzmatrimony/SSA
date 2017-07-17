//
//  ServiceModel.m
//  BarcodeScanner
//
//  Created by Surya Narayana Vennala on 11/10/14.
//  Copyright (c) 2014 Draconis Software. All rights reserved.
//

#import "ServiceModel.h"
#import "Constants.h"
#import "AFHTTPRequestOperation.h"
#import "Utility.h"

@implementation ServiceModel

/*+ (void)addAddress:(NSString *)inputParams WithShopPicture:(UIImage *)shopPicture andDocument:(UIImage *)documetPicture AddAddress:(void (^)(NSDictionary *result, NSError *error))block{
    NSString *requestString = [NSString stringWithFormat:@"%@registration",factailBaseURL];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:requestString]];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:inputParams forKey:@"data"];
    
    NSMutableURLRequest *request;
    //NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:requestString parameters:dict];
    if (shopPicture != nil) {
        request = [client multipartFormRequestWithMethod:@"POST" path:requestString parameters:dict constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
            NSData *imageToUpload = UIImageJPEGRepresentation(shopPicture, 1.0);
            [formData appendPartWithFileData: imageToUpload name:[NSString stringWithFormat:@"profile_picture"] fileName:[NSString stringWithFormat:@"profile_picture.png"] mimeType:@"image/png"];
            if (documetPicture != nil) {
                NSData *imageToUpload = UIImageJPEGRepresentation(documetPicture, 1.0);
                [formData appendPartWithFileData: imageToUpload name:[NSString stringWithFormat:@"doc_url"] fileName:[NSString stringWithFormat:@"doc_url.png"] mimeType:@"image/png"];
            }

        }];
    }
    
    if (request == nil) {
        request = [client requestWithMethod:@"POST" path:requestString parameters:dict];
    }
    
    
    //NSLog(@" Phno Verfication Code Request %@",request);
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject){
        @try {
            NSError *error;
            NSDictionary *mainDict = [[NSDictionary alloc] init];
            mainDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
            NSLog(@" Add address response %@",mainDict);
            block(mainDict,nil);
        }
        @catch (NSException *exception) {
            block(nil,[Utility showErrorWhenNetworkFailed]);
        }
        @finally {
            
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        block(nil,[Utility showErrorWhenNetworkFailed]);
    }];
    
    [client enqueueHTTPRequestOperation:operation];
}


+ (void)updateProfilePicture:(UIImage *)profilePicture WithInputParams:(NSString *)inputParams UpdateProfilePicture:(void (^)(NSDictionary *result, NSError *error))block{
    NSString *requestString = [NSString stringWithFormat:@"%@updateProfile",factailBaseURL];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:requestString]];

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:inputParams forKey:@"data"];
    NSMutableURLRequest *request;
    //NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:requestString parameters:dict];
    if (profilePicture != nil) {
        request = [client multipartFormRequestWithMethod:@"POST" path:requestString parameters:dict constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
            NSData *imageToUpload = UIImageJPEGRepresentation(profilePicture, 1.0);
            [formData appendPartWithFileData: imageToUpload name:[NSString stringWithFormat:@"DOC"] fileName:[NSString stringWithFormat:@"DOC.jpg"] mimeType:@"image/jpeg"];
        }];
    }
    
    if (request == nil) {
        request = [client requestWithMethod:@"POST" path:requestString parameters:dict];
    }
    
    
    //NSLog(@" Phno Verfication Code Request %@",request);
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject){
        @try {
            NSError *error;
            NSDictionary *mainDict = [[NSDictionary alloc] init];
            mainDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
            NSLog(@" update profile pic response %@",mainDict);
            block(mainDict,nil);
        }
        @catch (NSException *exception) {
            block(nil,[Utility showErrorWhenNetworkFailed]);
        }
        @finally {
            
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        block(nil,[Utility showErrorWhenNetworkFailed]);
    }];
    
    [client enqueueHTTPRequestOperation:operation];
}*/


+ (void)makeRequestFor:(int)requestType WithInputParams:(NSData *)inputParams AndToken:(NSString *)token MakeHttpRequest:(void (^)(NSDictionary *result, NSError* error))block{
    
    NSString *requestString;
    
    switch (requestType) {
        case ParentRegistration:
            requestString = [NSString stringWithFormat:@"%@http://49.207.0.196:8280/parentsRegistration/v1/parentRegistration",BaseURL];
            break;
        case KidRegistration:
            requestString = [NSString stringWithFormat:@"%@http://49.207.0.196:8280/addKids/v1/kidRegistration",BaseURL];
            break;
        case ConfirmSchool:
            requestString = [NSString stringWithFormat:@"%@http://49.207.0.196:8280/addingSchools/v1/parentSchoolRegistration",BaseURL];
            break;
        case ForgotPassword:
            requestString = [NSString stringWithFormat:@"%@http://49.207.0.196:8280/forgetpasword/1.0/forgotPassword",BaseURL];
            break;
        
        default:
            break;
    }
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:requestString]];

    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:requestString parameters:nil];
    
   
    [request setHTTPBody:inputParams];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
    
    //NSLog(@" Phno Verfication Code Request %@",request);
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject){
        @try {
            NSError *error;
            NSDictionary *mainDict = [[NSDictionary alloc] init];
            mainDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
            NSLog(@"response %@",mainDict);
            block(mainDict,nil);
        }
        @catch (NSException *exception) {
            block(nil,[Utility showErrorWhenNetworkFailed]);
        }
        @finally {
            
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSInteger statusCode = operation.response.statusCode;
        NSLog(@" Error Suggestion : %@",[error localizedRecoverySuggestion]);
        NSError *error1;
        if (statusCode == 401) {
            NSString *errorJsonString = [error localizedRecoverySuggestion];
            NSData *data = [errorJsonString dataUsingEncoding:NSUTF8StringEncoding];
            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if ([json objectForKey:@"fault"]) {
                if ([[[json objectForKey:@"fault"] objectForKey:@"code"] integerValue] == 900901) {
                    error1 = [NSError errorWithDomain:@"Network Error" code:statusCode userInfo:@{NSLocalizedDescriptionKey: TokenExpiredString}];
                }
            }else{
                error1 = [NSError errorWithDomain:@"Network Error" code:statusCode userInfo:@{NSLocalizedDescriptionKey: @"Authentication failed"}];
            }
            block(nil,error1);
        }
        block(nil,[Utility showErrorWhenNetworkFailed]);
    }];
    
    [client enqueueHTTPRequestOperation:operation];
}


+ (void)GetAccessTokenWithOutPassword:(void (^)(NSDictionary *result, NSError *error))block{
    NSString *requestString = @"http://49.207.0.196:8280/token";
    
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] init];
    [dataDict setObject:@"client_credentials" forKey:@"grant_type"];
    
    
    //Consumer Key : jiKoAXEw8OjWbAus_iYTrsdPVG4a
    //Consumer Secret : Kf3AksokLYwo6WLigvINp6bVV3Ma
    NSString *autherizationString = @"jiKoAXEw8OjWbAus_iYTrsdPVG4a:Kf3AksokLYwo6WLigvINp6bVV3Ma";
    
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:requestString]];
    
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:requestString parameters:dataDict];
    
    [request setValue:[NSString stringWithFormat:@"Basic %@",[ServiceModel encodeStringTo64:autherizationString]] forHTTPHeaderField:@"Authorization"];
    //[request setValue:@"Basic amlLb0FYRXc4T2pXYkF1c19pWVRyc2RQVkc0YTpLZjNBa3Nva0xZd282V0xpZ3ZJTnA2YlZWM01h" forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //NSLog(@" Phno Verfication Code Request %@",request);
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject){
        @try {
            NSError *error;
            NSDictionary *mainDict = [[NSDictionary alloc] init];
            mainDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
            NSLog(@"response %@",mainDict);
            block(mainDict,nil);
        }
        @catch (NSException *exception) {
            block(nil,[Utility showErrorWhenNetworkFailed]);
        }
        @finally {
            
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSInteger statusCode = operation.response.statusCode;
        NSLog(@" Error Suggestion : %@",[error localizedRecoverySuggestion]);
        if (statusCode == 400) {
            NSError *error = [NSError errorWithDomain:@"Network Error" code:statusCode userInfo:@{NSLocalizedDescriptionKey: @"Authentication failed"}];
            block(nil,error);
        }
        block(nil,[Utility showErrorWhenNetworkFailed]);
    }];
    
    [client enqueueHTTPRequestOperation:operation];
}

+ (void)getTokenWithUserName:(NSString *)userName AndPassword:(NSString *)password GetAccessToken:(void (^)(NSDictionary *result, NSError *error))block{
    NSString *requestString = @"http://49.207.0.196:8280/token";
    
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] init];
    [dataDict setObject:@"password" forKey:@"grant_type"];
    [dataDict setObject:userName forKey:@"username"];
    [dataDict setObject:password forKey:@"password"];
    
    
    //Consumer Key : jiKoAXEw8OjWbAus_iYTrsdPVG4a
    //Consumer Secret : Kf3AksokLYwo6WLigvINp6bVV3Ma
    NSString *autherizationString = @"jiKoAXEw8OjWbAus_iYTrsdPVG4a:Kf3AksokLYwo6WLigvINp6bVV3Ma";
    
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:requestString]];
    
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:requestString parameters:dataDict];
    
    [request setValue:[NSString stringWithFormat:@"Basic %@",[ServiceModel encodeStringTo64:autherizationString]] forHTTPHeaderField:@"Authorization"];
    //[request setValue:@"Basic amlLb0FYRXc4T2pXYkF1c19pWVRyc2RQVkc0YTpLZjNBa3Nva0xZd282V0xpZ3ZJTnA2YlZWM01h" forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    
    //NSLog(@" Phno Verfication Code Request %@",request);
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject){
        @try {
            NSError *error;
            NSDictionary *mainDict = [[NSDictionary alloc] init];
            mainDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
            NSLog(@"response %@",mainDict);
            block(mainDict,nil);
        }
        @catch (NSException *exception) {
            block(nil,[Utility showErrorWhenNetworkFailed]);
        }
        @finally {
            
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSInteger statusCode = operation.response.statusCode;
        NSLog(@" Error Suggestion : %@",[error localizedRecoverySuggestion]);
        if (statusCode == 400) {
            NSError *error = [NSError errorWithDomain:@"Network Error" code:statusCode userInfo:@{NSLocalizedDescriptionKey: @"Authentication failed"}];
            block(nil,error);
        }
        block(nil,[Utility showErrorWhenNetworkFailed]);
    }];
    
    [client enqueueHTTPRequestOperation:operation];
}

+ (NSString*)encodeStringTo64:(NSString*)fromString
{
    NSData *plainData = [fromString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String;
    if ([plainData respondsToSelector:@selector(base64EncodedStringWithOptions:)]) {
        base64String = [plainData base64EncodedStringWithOptions:kNilOptions];  // iOS 7+
    } else {
        base64String = [plainData base64Encoding];                              // pre iOS7
    }
    
    return base64String;
}

+ (void)makeGetRequestFor:(int)requestType WithInputParams:(NSString *)inputParams AndToken:(NSString *)token MakeHttpRequest:(void (^)(NSDictionary *result, NSError* error))block{
    
    NSString *requestString;
    
    switch (requestType) {
        case SchoolsList:
            requestString = [NSString stringWithFormat:@"%@http://49.207.0.196:8280/schooList/v1/schoolList?%@",BaseURL,inputParams];
            break;
        case AddSchool:
            requestString = [NSString stringWithFormat:@"%@http://49.207.0.196:8280/addingSchools/v1/parentSchoolRegistration?%@",BaseURL,inputParams];
            break;
        case KidsList:
            requestString = [NSString stringWithFormat:@"%@http://49.207.0.196:8280/kidList/v1/kidList?%@",BaseURL,inputParams];
            break;
        case GetProfile:
            requestString = [NSString stringWithFormat:@"%@http://49.207.0.196:8280/UserProfile/v1/getUserProfile?%@",BaseURL,inputParams];
            break;
        case ValidateEmail:
            requestString = [NSString stringWithFormat:@"%@http://49.207.0.196:8280/schoolRegistration/1.0/emailValidation?%@",BaseURL,inputParams];
            break;
        case KidListForTeacher:
            requestString = [NSString stringWithFormat:@"%@http://49.207.0.196:8280/kidInformation/v1/getKidInformation?%@",BaseURL,inputParams];
            break;
        case GetActivitiesList:
            requestString = [NSString stringWithFormat:@"%@http://49.207.0.196:8280/kidActivityInformation/v1/getKidActivityInformation?%@",BaseURL,inputParams];
            break;
        
        default:
            break;
    }
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:requestString]];
    
    NSMutableURLRequest *request = [client requestWithMethod:@"GET" path:requestString parameters:nil];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
    
    //NSLog(@" Phno Verfication Code Request %@",request);
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject){
        @try {
            NSError *error;
            NSDictionary *mainDict = [[NSDictionary alloc] init];
            mainDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
            NSLog(@"response %@",mainDict);
            block(mainDict,nil);
        }
        @catch (NSException *exception) {
            block(nil,[Utility showErrorWhenNetworkFailed]);
        }
        @finally {
            
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSInteger statusCode = operation.response.statusCode;
        NSLog(@" Error Suggestion : %@",[error localizedRecoverySuggestion]);
        NSError *error1;
        if (statusCode == 401) {
            NSString *errorJsonString = [error localizedRecoverySuggestion];
            NSData *data = [errorJsonString dataUsingEncoding:NSUTF8StringEncoding];
            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if ([json objectForKey:@"fault"]) {
                if ([[[json objectForKey:@"fault"] objectForKey:@"code"] integerValue] == 900901) {
                    error1 = [NSError errorWithDomain:@"Network Error" code:statusCode userInfo:@{NSLocalizedDescriptionKey: TokenExpiredString}];
                }
            }else{
                error1 = [NSError errorWithDomain:@"Network Error" code:statusCode userInfo:@{NSLocalizedDescriptionKey: @"Authentication failed"}];
            }
            block(nil,error1);
        }
        block(nil,[Utility showErrorWhenNetworkFailed]);
    }];
    
    [client enqueueHTTPRequestOperation:operation];
}



@end

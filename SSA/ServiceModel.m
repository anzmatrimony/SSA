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


+ (void)makeRequestFor:(int)requestType WithInputParams:(NSData *)inputParams MakeHttpRequest:(void (^)(NSDictionary *result, NSError* error))block{
    
    NSString *requestString;
    
    switch (requestType) {
        case ParentRegistration:
            requestString = [NSString stringWithFormat:@"%@http://49.207.0.196:8081/api/parentRegistration",BaseURL];
            break;
        case KidRegistration:
            requestString = [NSString stringWithFormat:@"%@http://49.207.0.196:8083/api/kidRegistration",BaseURL];
            break;
        case ConfirmSchool:
            requestString = [NSString stringWithFormat:@"%@http://49.207.0.196:8084/api/parentSchoolRegistration",BaseURL];
            break;
        
        default:
            break;
    }
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:requestString]];

    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:requestString parameters:nil];
    
   
    [request setHTTPBody:inputParams];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
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
        block(nil,[Utility showErrorWhenNetworkFailed]);
    }];
    
    [client enqueueHTTPRequestOperation:operation];
}


+ (void)makeGetRequestFor:(int)requestType WithInputParams:(NSString *)inputParams MakeHttpRequest:(void (^)(NSDictionary *result, NSError* error))block{
    
    NSString *requestString;
    
    switch (requestType) {
        case SchoolsList:
            requestString = [NSString stringWithFormat:@"%@http://49.207.0.196:8085/api/schoolList?%@",BaseURL,inputParams];
            break;
        case AddSchool:
            requestString = [NSString stringWithFormat:@"%@http://49.207.0.196:8084/api/parentSchoolRegistration?%@",BaseURL,inputParams];
            break;
        case KidsList:
            requestString = [NSString stringWithFormat:@"%@http://49.207.0.196:8088/api/kidList?%@",BaseURL,inputParams];
            break;
        
        default:
            break;
    }
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:requestString]];
    
    NSMutableURLRequest *request = [client requestWithMethod:@"GET" path:requestString parameters:nil];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
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
        block(nil,[Utility showErrorWhenNetworkFailed]);
    }];
    
    [client enqueueHTTPRequestOperation:operation];
}



@end

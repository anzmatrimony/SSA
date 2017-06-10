//
//  ServiceModel.h
//  BarcodeScanner
//
//  Created by Surya Narayana Vennala on 11/10/14.
//  Copyright (c) 2014 Draconis Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "AFHTTPClient.h"
#import <UIKit/UIKit.h>

@class AFHTTPRequestOperation;
@interface ServiceModel : NSObject



+ (void)addAddress:(NSString *)inputParams WithShopPicture:(UIImage *)shopPicture andDocument:(UIImage *)documetPicture AddAddress:(void (^)(NSDictionary *result, NSError *error))block;

+ (void)getAddressForLatitude:(NSString *)latitude AndLongitude:(NSString *)longitude GetAddress:(void (^)(NSDictionary *result, NSError *error))block;

+ (void)makeRequestFor:(int)requestType WithInputParams:(NSData *)inputParams AndToken:(NSString *)token MakeHttpRequest:(void (^)(NSDictionary *result, NSError* error))block;

+ (void)makeGetRequestFor:(int)requestType WithInputParams:(NSString *)inputParams AndToken:(NSString *)token MakeHttpRequest:(void (^)(NSDictionary *result, NSError* error))block;

+ (void)updateProfilePicture:(UIImage *)profilePicture WithInputParams:(NSString *)inputParams UpdateProfilePicture:(void (^)(NSDictionary *result, NSError *error))block;
//+ (void)checkVersion:(NSString *)version CheckVersion:(void (^)(NSDictionary *result, NSError *error))block;

+ (void)downloadInvoiceFor:(NSString *)orderId Invoice:(void (^)(NSDictionary *result, NSError *error))block;

+ (void)getTokenWithUserName:(NSString *)userName AndPassword:(NSString *)password GetAccessToken:(void (^)(NSDictionary *result, NSError *error))block;

+ (void)GetAccessTokenWithOutPassword:(void (^)(NSDictionary *result, NSError *error))block;
@end

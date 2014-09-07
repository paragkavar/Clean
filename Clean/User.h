//
//  User.h
//  Clean
//
//  Created by Sapan Bhuta on 9/2/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
+ (BOOL)started;
+ (void)setStarted:(BOOL)newStarted;
+ (NSString *)verifiedPhoneNumber;
+ (void)setVerifiedPhoneNumber:(NSString *)newVerifiedPhoneNumber;
+ (NSString *)phoneNumber;
+ (void)setPhoneNumber:(NSString *)newPhoneNumber;
+ (NSString *)address;
+ (void)setAddress:(NSString *)newAddress;
+ (CGFloat)latitude;
+ (void)setLatitude:(CGFloat)newLatitude;
+ (CGFloat)longitude;
+ (void)setLongitude:(CGFloat)newLongitude;
+ (NSString *)day;
+ (void)setDay:(NSString *)newDay;
+ (int)hour;
+ (void)setHour:(int)newHour;
+ (int)minute;
+ (void)setMinute:(int)newMinute;
+ (BOOL)AM;
+ (void)setAM:(BOOL)newAM;
+ (int)plan;
+ (void)setPlan:(int)newPlan;
+ (NSString *)last4;
+ (void)setLast4:(NSString *)newLast4;
+ (NSString *)customerId;
+ (void)setCustomerId:(NSString *)newCustomerId;
+ (NSString *)subscriptionId;
+ (void)setSubscriptionId:(NSString *)newSubscriptionId;
@end
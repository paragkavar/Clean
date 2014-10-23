//
//  User.m
//  Clean
//
//  Created by Sapan Bhuta on 9/2/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#import "User.h"

//static NSString *phoneNumber;
//static NSString *address;
//static CGFloat latitude;
//static CGFloat longitude;
//static NSString *day;
//static int hour;
//static int minute;
//static bool AM;
//static int plan;
//static NSString *last4;
//static NSString *customerId;
//static NSString *subscriptionId;

@implementation User

+ (BOOL)started
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"started"];
}

+ (void)setStarted:(BOOL)newStarted
{
    [[NSUserDefaults standardUserDefaults] setBool:newStarted forKey:@"started"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)verifiedPhoneNumber
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"verifiedPhoneNumber"];
}

+ (void)setVerifiedPhoneNumber:(NSString *)newVerifiedPhoneNumber
{
    [[NSUserDefaults standardUserDefaults] setObject:newVerifiedPhoneNumber forKey:@"verifiedPhoneNumber"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)phoneNumber
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"];
}

+ (void)setPhoneNumber:(NSString *)newPhoneNumber
{
    [[NSUserDefaults standardUserDefaults] setObject:newPhoneNumber forKey:@"phoneNumber"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)address
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"address"];
}

+ (void)setAddress:(NSString *)newAddress
{
    [[NSUserDefaults standardUserDefaults] setObject:newAddress forKey:@"address"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (CGFloat)latitude
{
    return [[NSUserDefaults standardUserDefaults] floatForKey:@"latitude"];
}

+ (void)setLatitude:(CGFloat)newLatitude
{
    [[NSUserDefaults standardUserDefaults] setFloat:newLatitude forKey:@"latitude"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (CGFloat)longitude
{
    return [[NSUserDefaults standardUserDefaults] floatForKey:@"longitude"];
}

+ (void)setLongitude:(CGFloat)newLongitude
{
    [[NSUserDefaults standardUserDefaults] setFloat:newLongitude forKey:@"longitude"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)day
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"day"];
}

+ (void)setDay:(NSString *)newDay
{
    [[NSUserDefaults standardUserDefaults] setObject:newDay forKey:@"day"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (int)hour
{
    return (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"hour"];
}

+ (void)setHour:(int)newHour
{
    [[NSUserDefaults standardUserDefaults] setInteger:newHour forKey:@"hour"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (int)minute
{
    return (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"minute"];
}

+ (void)setMinute:(int)newMinute
{
    [[NSUserDefaults standardUserDefaults] setInteger:newMinute forKey:@"minute"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)AM
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"AM"];
}

+ (void)setAM:(BOOL)newAM
{
    [[NSUserDefaults standardUserDefaults] setBool:newAM forKey:@"AM"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (int)plan
{
    return (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"plan"];
}

+ (void)setPlan:(int)newPlan
{
    [[NSUserDefaults standardUserDefaults] setInteger:newPlan forKey:@"plan"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)last4
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"last4"];
}

+ (void)setLast4:(NSString *)newLast4
{
    [[NSUserDefaults standardUserDefaults] setObject:newLast4 forKey:@"last4"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)customerId
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"customerId"];
}

+ (void)setCustomerId:(NSString *)newCustomerId
{
    [[NSUserDefaults standardUserDefaults] setObject:newCustomerId forKey:@"customerId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)subscriptionId
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"subscriptionId"];
}

+ (void)setSubscriptionId:(NSString *)newSubscriptionId
{
    [[NSUserDefaults standardUserDefaults] setObject:newSubscriptionId forKey:@"subscriptionId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end

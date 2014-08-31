//
//  VCFlow.m
//  Clean
//
//  Created by Sapan Bhuta on 8/31/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#import "VCFlow.h"
#import <Parse/Parse.h>
#import "IntroViewController.h"
#import "GetPhoneNumberViewController.h"
#import "GetAddressViewController.h"
#import "GetHomeInfoViewController.h"
#import "GetPaymentCardViewController.h"
#import "SubscribeViewController.h"
#import "RootViewController.h"

@implementation VCFlow

+ (UIViewController *)nextVC
{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"started"])
    {
        return [IntroViewController new];
    }
    else if (![[NSUserDefaults standardUserDefaults] objectForKey:@"verifiedPhoneNumber"])
    {
        return [GetPhoneNumberViewController new];
    }
    else if (![[NSUserDefaults standardUserDefaults] objectForKey:@"address"])
    {
        return [GetAddressViewController new];
    }
    else if (![[NSUserDefaults standardUserDefaults] objectForKey:@"bedrooms"] &&
             ![[NSUserDefaults standardUserDefaults] objectForKey:@"bathrooms"])
    {
        return [GetHomeInfoViewController new];
    }
    else if (![[NSUserDefaults standardUserDefaults] objectForKey:@"customerId"])
    {
        return [GetPaymentCardViewController new];
    }
    else if (![[NSUserDefaults standardUserDefaults] objectForKey:@"subscriptionId"])
    {
        return [SubscribeViewController new];
    }
    else
    {
        return [RootViewController new];
    }
}

+ (void)checkForExistingUserWithCompletionHandler:(void (^)(bool exists))handler
{
    PFQuery *query = [PFQuery queryWithClassName:@"User"];
    [query whereKey:@"phoneNumber" equalTo:[[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects.count==0) {
            handler(NO);
        } else {
            PFObject *user = objects.firstObject;
            [[NSUserDefaults standardUserDefaults] setObject:user[@"phoneNumber"] forKey:@"phoneNumber"];
            [[NSUserDefaults standardUserDefaults] setObject:user[@"address"] forKey:@"address"];
            [[NSUserDefaults standardUserDefaults] setObject:user[@"bedrooms"] forKey:@"bedrooms"];
            [[NSUserDefaults standardUserDefaults] setObject:user[@"bathrooms"] forKey:@"bathrooms"];
            [[NSUserDefaults standardUserDefaults] setObject:user[@"customerId"] forKey:@"customerId"];
            [[NSUserDefaults standardUserDefaults] setObject:user[@"subscriptionId"] forKey:@"subscriptionId"];
            [[NSUserDefaults standardUserDefaults] setObject:user[@"visits"] forKey:@"visits"];
            handler(YES);
        }
    }];
}

+ (void)addUserToDataBase
{
    PFObject *user = [PFObject objectWithClassName:@"User"];
    user[@"phoneNumber"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"];
    user[@"address"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"address"];
    user[@"bedrooms"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"bedrooms"];
    user[@"bathrooms"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"bathrooms"];
    user[@"customerId"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"customerId"];
    user[@"subscriptionId"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"subscriptionId"];
    user[@"visits"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"visits"];
    [user saveInBackground];
}

@end

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
#import "GetPriceViewController.h"
#import "GetPaymentCardViewController.h"
#import "RootViewController.h"

@implementation VCFlow

+ (UIViewController *)nextVC
{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"started"])
    {
        return [IntroViewController new];
    }
    else if (![[NSUserDefaults standardUserDefaults] boolForKey:@"verifiedPhoneNumber"])
    {
        return [GetPhoneNumberViewController new];
    }
    else if (![[NSUserDefaults standardUserDefaults] objectForKey:@"address"])
    {
        return [GetAddressViewController new];
    }
    else if (![[NSUserDefaults standardUserDefaults] objectForKey:@"plan"])
    {
        return [GetPriceViewController new];
    }
    else if (![[NSUserDefaults standardUserDefaults] objectForKey:@"subscriptionId"])
    {
        return [GetPaymentCardViewController new];
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
            [[NSUserDefaults standardUserDefaults] setFloat:[user[@"latitude"] floatValue] forKey:@"latitude"];
            [[NSUserDefaults standardUserDefaults] setFloat:[user[@"longitude"] floatValue] forKey:@"longitude"];
            [[NSUserDefaults standardUserDefaults] setObject:user[@"day"] forKey:@"hour"];
            [[NSUserDefaults standardUserDefaults] setInteger:[user[@"hour"] intValue] forKey:@"visits"];
            [[NSUserDefaults standardUserDefaults] setInteger:[user[@"minute"] intValue] forKey:@"minute"];
            [[NSUserDefaults standardUserDefaults] setBool:[user[@"AM"] boolValue] forKey:@"AM"];
            [[NSUserDefaults standardUserDefaults] setObject:user[@"plan"] forKey:@"plan"];
            [[NSUserDefaults standardUserDefaults] setObject:user[@"customerId"] forKey:@"customerId"];
            [[NSUserDefaults standardUserDefaults] setObject:user[@"subscriptionId"] forKey:@"subscriptionId"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            handler(YES);
        }
    }];
}

+ (void)addUserToDataBase
{
    PFObject *user = [PFObject objectWithClassName:@"User"];
    user[@"phoneNumber"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"];
    user[@"address"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"address"];
    user[@"latitude"] = @([[NSUserDefaults standardUserDefaults] floatForKey:@"latitude"]);
    user[@"longitude"] = @([[NSUserDefaults standardUserDefaults] floatForKey:@"longitude"]);
    user[@"day"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"day"];
    user[@"hour"] = @([[NSUserDefaults standardUserDefaults] integerForKey:@"hour"]);
    user[@"minute"] = @([[NSUserDefaults standardUserDefaults] integerForKey:@"minute"]);
    user[@"AM"] = @([[NSUserDefaults standardUserDefaults] boolForKey:@"AM"]);
    user[@"plan"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"plan"];
    user[@"customerId"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"customerId"];
    user[@"subscriptionId"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"subscriptionId"];
    [user saveInBackground];
}

@end
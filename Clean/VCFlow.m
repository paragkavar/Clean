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
#import "GetPlanViewController.h"
#import "GetPayCardViewController.h"
#import "RootViewController.h"
#import "User.h"

@implementation VCFlow

+ (UIViewController *)nextVC
{
    if (![User started])
    {
        return [IntroViewController new];
    }
    else if (![User verifiedPhoneNumber])
    {
        return [GetPhoneNumberViewController new];
    }
    else if (![User address])
    {
        return [GetAddressViewController new];
    }
    else if (![User customerId])
    {
        return [GetPayCardViewController new];
    }
    else if (![User plan])
    {
        return [GetPlanViewController new];
    }
    else
    {
        return [RootViewController new];
    }
}

+ (void)checkForExistingUserWithCompletionHandler:(void (^)(bool exists))handler
{
    PFQuery *query = [PFQuery queryWithClassName:@"User"];
    [query whereKey:@"phoneNumber" equalTo:[User phoneNumber]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects.count==0) {
            handler(NO);
        } else {
            PFObject *user = objects.firstObject;
            [self getParseDataFromUser:user];
            handler(YES);
        }
    }];
}

+ (void)getParseDataFromUser:(PFObject *)user
{
    [User setPhoneNumber:user[@"phoneNumber"]];
    [User setAddress:user[@"address"]];
    [User setLatitude:[user[@"latitude"] floatValue]];
    [User setLongitude:[user[@"longitude"] floatValue]];
    [User setDay:user[@"day"]];
    [User setHour:[user[@"hour"] intValue]];
    [User setMinute:[user[@"minute"] intValue]];
    [User setAM:[user[@"AM"] boolValue]];
    [User setPlan:[user[@"plan"] intValue]];
    [User setLast4:user[@"last4"]];
    [User setCustomerId:user[@"customerId"]];
    [User setSubscriptionId:user[@"subscriptionId"]];
}

+ (void)addUserToDataBase
{
    PFObject *user = [PFObject objectWithClassName:@"User"];
    [self saveUserToParse:user];
}

+ (void)updateUserInParse
{
    PFQuery *query = [PFQuery queryWithClassName:@"User"];
    [query whereKey:@"phoneNumber" equalTo:[User phoneNumber]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error || objects.count !=1)
        {
            //fatal problems in database
        }
        else
        {
            [self saveUserToParse:objects.firstObject];
        }
    }];
}

+ (void)saveUserToParse:(PFObject *)user
{
    user[@"phoneNumber"] = [User phoneNumber];
    user[@"address"] = [User address];
    user[@"latitude"] = @([User latitude]);
    user[@"longitude"] = @([User longitude]);
    user[@"day"] = [User day];
    user[@"hour"] = @([User hour]);
    user[@"minute"] = @([User minute]);
    user[@"AM"] = @([User AM]);
    user[@"plan"] = @([User plan]);
    user[@"last4"] = [User last4];
    user[@"customerId"] = [User customerId];
    user[@"subscriptionId"] = [User subscriptionId];
    [user saveInBackground];
}

@end
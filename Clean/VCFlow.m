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
#warning use Parse from plan
}

@end
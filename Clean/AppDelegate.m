//
//  AppDelegate.m
//  Clean
//
//  Created by Sapan Bhuta on 8/27/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#import "AppDelegate.h"
#import "IntroViewController.h"
#import "GetPhoneNumberViewController.h"
#import "GetAddressViewController.h"
#import "GetPaymentCardViewController.h"
#import "RootViewController.h"
#import <Parse/Parse.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse setApplicationId:@"53godaMM1NHAkE58b6w4ezaZ1bytmhxhF9BjCsCQ"
                  clientKey:@"IA2yhwm7jzhuUK5DvNx4DSk3c9gkmk2xNhovZB8c"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [AppDelegate nextVC];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

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
    else if (![[NSUserDefaults standardUserDefaults] objectForKey:@"stripeToken"])
    {
        return [GetPaymentCardViewController new];
    }
    else
    {
        return [RootViewController new];
    }
}

@end

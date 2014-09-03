//
//  SetPayCardViewController.m
//  Clean
//
//  Created by Sapan Bhuta on 9/1/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#import "SetPayCardViewController.h"
#import "UIColor+FlatUI.h"
#import <Parse/Parse.h>
#import "VCFlow.h"

@interface SetPayCardViewController ()
@end

@implementation SetPayCardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [super.subscribe setFlatTitle:@"save"];
    [self createButtons];
    super.page.hidden = YES;
}

- (void)createButtons
{
    super.back.frame = CGRectMake(0, self.view.frame.size.height-216-54, self.view.frame.size.width/2-.25, 54);
    super.subscribe.frame = CGRectMake(self.view.frame.size.width/2+.25, self.view.frame.size.height-216-54, self.view.frame.size.width/2-.25, 54);
}

- (void)handleStripeToken:(STPToken *)token
{
    [self updateCustomer:token];
}

- (void)updateCustomer:(STPToken *)token
{
    NSString *customerId = [[NSUserDefaults standardUserDefaults] objectForKey:@"customerId"];
    [PFCloud callFunctionInBackground:@"updateCustomer"
                       withParameters:@{@"customer":customerId, @"token":token.tokenId}
                                block:^(NSString *customerId, NSError *error)
     {
         if (error)
         {
             [super handleStripeError:error];
         }
         else
         {
             [[NSUserDefaults standardUserDefaults] setObject:customerId forKey:@"customerId"];
             [[NSUserDefaults standardUserDefaults] setObject:super.last4 forKey:@"last4"];
             [[NSUserDefaults standardUserDefaults] synchronize];
             [VCFlow updateUserInParse];
             [self dismissViewControllerAnimated:YES completion:nil];
         }
     }];
}

- (void)displayErrorAlert
{
    [[[UIAlertView alloc] initWithTitle:@"Error trying to update card" message:@"Please try again with a good network connection and a working card" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}

@end

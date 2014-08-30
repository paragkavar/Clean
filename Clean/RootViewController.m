//
//  RootViewController.m
//  Clean
//
//  Created by Sapan Bhuta on 8/27/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#define shimmeringFrame CGRectMake(15,20,290,55)
#define dateFrame CGRectMake(0, 80, 320, 115)
#define buttonFrame CGRectMake(0, self.view.frame.size.height-54, self.view.frame.size.width, 54)

#import "RootViewController.h"
#import "JSQFlatButton.h"
#import "UIColor+FlatUI.h"
#import "FBShimmeringView.h"
#import <Parse/Parse.h>

@interface RootViewController () <UIAlertViewDelegate>
@property JSQFlatButton *clean;
@property UIDatePicker *datePicker;
@property UIActivityIndicatorView *activity;
@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor midnightBlueColor];
    [self createTitle];
    [self createDatePicker];
    [self createButton];
    [self createActivityView];
}

- (void)createTitle
{
    FBShimmeringView *shimmeringView = [[FBShimmeringView alloc] initWithFrame:shimmeringFrame];
    [self.view addSubview:shimmeringView];
    UILabel *loadingLabel = [[UILabel alloc] initWithFrame:shimmeringView.bounds];
    loadingLabel.textAlignment = NSTextAlignmentCenter;
    loadingLabel.textColor = [UIColor whiteColor];
    loadingLabel.text = @"Clean";
    loadingLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:50];
    shimmeringView.contentView = loadingLabel;
    shimmeringView.shimmering = YES;
}

- (void)createDatePicker
{
    _datePicker = [[UIDatePicker alloc] initWithFrame:dateFrame];
//    _datePicker.datePickerMode = UIDatePickerModeTime;
    _datePicker.center = self.view.center;
    [self.view addSubview:_datePicker];
}

- (void)createActivityView
{
    _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activity.center = _datePicker.center;
    [_activity hidesWhenStopped];
    [self.view addSubview:_activity];
}

- (void)createButton
{
    self.clean = [[JSQFlatButton alloc] initWithFrame:buttonFrame
                                      backgroundColor:[UIColor colorWithRed:1.00f green:1.00f blue:1.00f alpha:1.0f]
                                      foregroundColor:[UIColor colorWithRed:0.35f green:0.35f blue:0.81f alpha:1.0f]
                                                title:@"Clean"
                                                image:nil];
    [self.clean addTarget:self action:@selector(clean:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.clean];
}

- (void)clean:(JSQFlatButton *)sender
{
    _clean.enabled = NO;
    [_activity startAnimating];
    [self createCharge];
}

- (void)createCharge
{
    NSString *bedrooms = [[NSUserDefaults standardUserDefaults] stringForKey:@"bedrooms"];
    NSString *bathrooms = [[NSUserDefaults standardUserDefaults] stringForKey:@"bathrooms"];

    [PFCloud callFunctionInBackground:@"costCalc"
                       withParameters:@{@"bedrooms":bedrooms, @"bathrooms":bathrooms}
                                block:^(NSString *amount, NSError *error)
     {
         if (!error)
         {
             NSString *customerId = [[NSUserDefaults standardUserDefaults] objectForKey:@"customerId"];
             [PFCloud callFunctionInBackground:@"createCharge"
                                withParameters:@{@"amount":amount, @"customer":customerId}
                                         block:^(id chargeId, NSError *error)
              {
                  [_activity stopAnimating];
                  if (!error)
                  {
                      NSString *message = [NSString stringWithFormat:@"Cleaner will come on %@",[self getDate]];
                      [[[UIAlertView alloc] initWithTitle:@"Awesome!"
                                                  message:message
                                                 delegate:self
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles:nil, nil] show];
                      [self recordTransaction:chargeId];
                  }
                  else
                  {
                      [[[UIAlertView alloc] initWithTitle:@"Error creating charge"
                                                  message:@"Please check your network connection and try again"
                                                 delegate:self
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles:nil, nil] show];
                  }
              }];
         }
         else
         {
             [_activity stopAnimating];
             [[[UIAlertView alloc] initWithTitle:@"Error creating charge"
                                         message:@"Please check your network connection and try again"
                                        delegate:self
                               cancelButtonTitle:@"OK"
                               otherButtonTitles:nil, nil] show];
         }
     }];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    _clean.enabled = YES;
}

- (void)recordTransaction:(NSString *)chargeId
{
    PFObject *transaction = [PFObject objectWithClassName:@"Transaction"];
    transaction[@"phoneNumber"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"];
    transaction[@"address"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"address"];
    transaction[@"date"] = [self getDate];
    transaction[@"customerId"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"customerId"];
    transaction[@"chargeId"] = chargeId;
    [transaction saveInBackground];
}

- (NSString *)getDate
{
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSDate *pickerDate = [_datePicker date];
    NSString *selectionString = [[NSString alloc] initWithFormat:@"%@", [pickerDate descriptionWithLocale:usLocale]];
    return selectionString;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end

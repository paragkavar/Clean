//
//  SetPlanViewController.m
//  Clean
//
//  Created by Sapan Bhuta on 9/1/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#warning problem highlighting mansion box at index 3 in super.collectionView
#warning also update new subscription prefrences in Stripe for customer, and make any immdeiate charges necessary
#warning problems with button enable-disable

#import "SetPlanViewController.h"
#import "UIColor+FlatUI.h"
#import "VCFlow.h"
#import <Parse/Parse.h>

@interface SetPlanViewController () <UIPickerViewDelegate>

@end

@implementation SetPlanViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    super.page.hidden = YES;
    [self createButtons];

    super.dayPicker.delegate = self;
    super.timePicker.delegate = self;
    //create 2 Buttons
    //hide save button
}

- (void)viewDidAppear:(BOOL)animated
{
    NSIndexPath *path = [NSIndexPath indexPathForItem:[[NSUserDefaults standardUserDefaults] integerForKey:@"plan"] inSection:0];
    [super.collectionView selectItemAtIndexPath:path animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    UICollectionViewCell *cell = [super.collectionView cellForItemAtIndexPath:path];
    cell.contentView.layer.borderWidth = 1;
    cell.contentView.layer.borderColor = [UIColor whiteColor].CGColor;

    int dayIndex = [super.days indexOfObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"day"]];
    [super.dayPicker selectRow:dayIndex inComponent:0 animated:YES];
    [super.timePicker selectRow:[[NSUserDefaults standardUserDefaults] integerForKey:@"hour"]-1 inComponent:0 animated:YES];
    [super.timePicker selectRow:[[NSUserDefaults standardUserDefaults] integerForKey:@"minute"] inComponent:1 animated:YES];
    [super.timePicker selectRow:[[NSUserDefaults standardUserDefaults] boolForKey:@"AM"] ? 0 : 1 inComponent:2 animated:YES];

    super.dayPicker.delegate = self;
    super.timePicker.delegate = self;
}

- (void)createButtons
{
    super.back.frame = CGRectMake(0, self.view.frame.size.height-54, self.view.frame.size.width/2-.25, 54);
    super.save.frame = CGRectMake(self.view.frame.size.width/2+.25,self.view.frame.size.height-54,self.view.frame.size.width/2-.25,54);
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    super.save.enabled = [super dateChanged];
}

- (void)nextVC
{
    [self updateSubscripton];
}

- (void)updateSubscripton
{
    NSString *customerId = [[NSUserDefaults standardUserDefaults] objectForKey:@"customerId"];
    NSString *subscriptionId = [[NSUserDefaults standardUserDefaults] objectForKey:@"subscriptionId"];
    NSString *plan = [[NSUserDefaults standardUserDefaults] objectForKey:@"plan"];
    [PFCloud callFunctionInBackground:@"updateSubscription"
                       withParameters:@{@"customer":customerId, @"subscription":subscriptionId, @"plan":plan}
                                block:^(NSString *subscriptionId, NSError *error)
     {
         if (error)
         {
             [self handleStripeError:error];
         }
         else
         {
             [self handleStripeSuccess:subscriptionId];
         }
     }];
}

- (void)handleStripeError:(NSError *)error
{

}

- (void)handleStripeSuccess:(NSString *)subscriptionId
{
    [[NSUserDefaults standardUserDefaults] setObject:subscriptionId forKey:@"subscriptionId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [VCFlow updateUserInParse];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)displayErrorAlert
{
    [[[UIAlertView alloc] initWithTitle:@"Error trying to update card" message:@"Please try again with a good network connection and a working card" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}
@end

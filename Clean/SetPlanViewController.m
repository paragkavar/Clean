//
//  SetPlanViewController.m
//  Clean
//
//  Created by Sapan Bhuta on 9/1/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#warning minor: problem highlighting mansion box at index 3 in super.collectionView

#import "SetPlanViewController.h"
#import "VCFlow.h"
#import <Parse/Parse.h>
#import "User.h"
#import "ParseLogic.h"

@interface SetPlanViewController ()

@end

@implementation SetPlanViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    super.page.hidden = YES;
    [self createButtons];
}

- (void)viewDidAppear:(BOOL)animated
{
    if ([User plan] >= 0)
    {
        super.selectedIndex = [User plan];
        NSIndexPath *path = [NSIndexPath indexPathForItem:super.selectedIndex inSection:0];
        [super.collectionView selectItemAtIndexPath:path animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
        UICollectionViewCell *cell = [super.collectionView cellForItemAtIndexPath:path];
        cell.contentView.layer.borderWidth = 1;
        cell.contentView.layer.borderColor = [UIColor whiteColor].CGColor;
    }

    int dayIndex = [super.days indexOfObject:[User day]];
    [super.dayPicker selectRow:dayIndex inComponent:0 animated:YES];
    [super.timePicker selectRow:[User hour]-1 inComponent:0 animated:YES];
    [super.timePicker selectRow:[User minute] inComponent:1 animated:YES];
    [super.timePicker selectRow:[User AM] ? 0 : 1 inComponent:2 animated:YES];
}

- (void)createButtons
{
    super.back.frame = CGRectMake(0, self.view.frame.size.height-54, self.view.frame.size.width/2-.25, 54);
    super.save.frame = CGRectMake(self.view.frame.size.width/2+.25,self.view.frame.size.height-54,self.view.frame.size.width/2-.25,54);
}

- (void)save:(JSQFlatButton *)sender
{
    if ([super dateChanged] && ![super planChanged])
    {
        [self updateTimes];
        [ParseLogic updateUserInParse];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if ([super dateChanged] && [super planChanged])
    {
        [self updateTimes];
        [ParseLogic updateUserInParse];
        ![User subscriptionId] ? [self createSubscription] : [self updateSubscripton];
    }
    else if (![super dateChanged] && [super planChanged])
    {
        ![User subscriptionId] ? [self createSubscription] : [self updateSubscripton];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)createSubscription
{
    super.back.enabled = NO;
    super.save.enabled = NO;
    [PFCloud callFunctionInBackground:@"createSubscription"
                       withParameters:@{@"customer":[User customerId], @"plan":@(super.selectedIndex).description}
                                block:^(NSString *subscriptionId, NSError *error)
     {
         if (error)
         {
             super.back.enabled = YES;
             super.save.enabled = YES;
             [[[UIAlertView alloc] initWithTitle:@"Error trying to subscribe" message:@"Please try again with a good network connection and a working card" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
         }
         else
         {
             [User setSubscriptionId:subscriptionId];
             [super saveValues];
             [ParseLogic updateUserInParse];
             [self dismissViewControllerAnimated:YES completion:nil];
         }
     }];
}

- (void)updateSubscripton
{
    super.back.enabled = NO;
    super.save.enabled = NO;
    [PFCloud callFunctionInBackground:@"updateSubscription"
                       withParameters:@{@"customer":[User customerId], @"subscription":[User subscriptionId], @"plan":@(super.selectedIndex).description}
                                block:^(NSString *subscriptionId, NSError *error)
     {
         if (error)
         {
             super.back.enabled = YES;
             super.save.enabled = YES;
             [[[UIAlertView alloc] initWithTitle:@"Error trying to update card" message:@"Please try again with a good network connection and a working card" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
         }
         else
         {
             [User setPlan:super.selectedIndex];
             [super saveValues];
             [ParseLogic updateUserInParse];
             [self dismissViewControllerAnimated:YES completion:nil];
         }
     }];
}

- (void)updateTimes
{
    [User setDay:super.days[[super.dayPicker selectedRowInComponent:0]]];
    [User setHour:[super.timePicker selectedRowInComponent:0]+1];
    [User setMinute:[super.timePicker selectedRowInComponent:1]];
    [User setAM:[super.timePicker selectedRowInComponent:2] == 0];
}

@end

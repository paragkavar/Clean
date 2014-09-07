//
//  GetHomeInfoViewController.m
//  Clean
//
//  Created by Sapan Bhuta on 8/29/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#import "GetPlanViewController.h"
#import "RootViewController.h"
#import "UIColor+FlatUI.h"
#import <Parse/Parse.h>
#import "PRCollectionViewCell.h"
#import "VCFlow.h"
#import "User.h"
#import "ParseLogic.h"

@interface GetPlanViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
@end

@implementation GetPlanViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _selectedIndex = -1;
    self.view.backgroundColor = [UIColor midnightBlueColor];
    _days = @[@"Sunday",@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday"];
    [self createPage];
    [self createTitle];
    [self createButton];
    [self createCollectionView];
    [self createPickers];
}

- (void)createPage
{
    _page = [[UIPageControl alloc] init];
    _page.center = CGPointMake(self.view.center.x, 100);
    _page.numberOfPages = 5;
    _page.currentPage = 3;
    _page.backgroundColor = [UIColor clearColor];
    _page.tintColor = [UIColor whiteColor];
    _page.currentPageIndicatorTintColor = [UIColor colorWithRed:0.0f green:0.49f blue:0.96f alpha:1.0f];
    [self.view addSubview:_page];
}

- (void)createTitle
{
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, self.view.frame.size.width-2*10, 50)];
    title.text = @"Set up repeat visits?";
    title.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:50];
    title.textColor = [UIColor whiteColor];
    title.adjustsFontSizeToFitWidth = YES;
    title.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:title];
}

- (void)createButton
{
    _later =  [[JSQFlatButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-54, self.view.frame.size.width/2-.25, 54)
                                   backgroundColor:[UIColor colorWithRed:0.18f green:0.67f blue:0.84f alpha:1.0f]
                                   foregroundColor:[UIColor colorWithRed:1.00f green:1.00f blue:1.00f alpha:1.0f]
                                             title:@"later"
                                             image:nil];
    [_later addTarget:self action:@selector(later:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_later];

    _back = [[JSQFlatButton alloc] initWithFrame:CGRectZero
                                 backgroundColor:[UIColor colorWithRed:0.18f green:0.67f blue:0.84f alpha:1.0f]
                                 foregroundColor:[UIColor colorWithRed:1.00f green:1.00f blue:1.00f alpha:1.0f]
                                           title:@"back"
                                           image:nil];
    [_back addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_back];

    _save = [[JSQFlatButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2+.25, self.view.frame.size.height-54, self.view.frame.size.width/2-.25, 54)
                                 backgroundColor:[UIColor colorWithRed:1.00f green:1.00f blue:1.00f alpha:1.0f]
                                 foregroundColor:[UIColor colorWithRed:0.35f green:0.35f blue:0.81f alpha:1.0f]
                                           title:@"save"
                                           image:nil];
    [_save addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_save];
    _save.enabled = NO;
}

- (void)later:(JSQFlatButton *)sender
{
    [self saveValues];
    [ParseLogic addUserToDataBase];
    [self nextVC];
}

- (void)back:(JSQFlatButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)createPickers
{
    UILabel *day = [[UILabel alloc] initWithFrame:CGRectMake(20, 300, 280, 40)];
    day.textAlignment = NSTextAlignmentCenter;
    day.textColor = [UIColor whiteColor];
    day.text = @"pick a time";
    day.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:30];
    day.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:day];

    _timePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(160, 330, 160, 120)];
    _timePicker.dataSource = self;
    _timePicker.delegate = self;
    _timePicker.tag = 1;
    [self.view addSubview:_timePicker];

    _dayPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 330, 160, 120)];
    _dayPicker.dataSource = self;
    _dayPicker.delegate = self;
    _dayPicker.tag = 0;
    [self.view addSubview:_dayPicker];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (pickerView.tag == 0)
    {
        return 1;
    }
    else
    {
        return 3;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag == 0)
    {
        return _days.count;
    }
    else
    {
        if (component == 0)
        {
            return 12;
        }
        else if (component == 1)
        {
            return 60;
        }
        else
        {
            return 2;
        }
    }
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView.tag == 0)
    {
        NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:_days[row]];
        [title addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [title length])];
        return title;
    }
    else
    {
        if (component == 0)
        {
            NSMutableAttributedString *hour = [[NSMutableAttributedString alloc] initWithString:@(row+1).description];
            [hour addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [hour length])];
            return hour;
        }
        else if (component == 1)
        {
            NSString *numString = @(row).description;
            if (row<10)
            {
                numString = [@"0" stringByAppendingString:numString];
            }

            NSMutableAttributedString *minute = [[NSMutableAttributedString alloc] initWithString:numString];
            [minute addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [minute length])];
            return minute;
        }
        else
        {
            NSMutableAttributedString *noon = [[NSMutableAttributedString alloc] initWithString: row==0 ? @"AM" : @"PM"];
            [noon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [noon length])];
            return noon;
        }
    }
}

- (void)save:(JSQFlatButton *)sender
{
    _save.enabled = NO;
    [self createSubscription];
}

- (void)saveValues
{
    [User setPlan:_selectedIndex];
    [User setDay:_days[[_dayPicker selectedRowInComponent:0]]];
    [User setHour:[_timePicker selectedRowInComponent:0]+1];
    [User setMinute:[_timePicker selectedRowInComponent:1]];
    [User setAM:[_timePicker selectedRowInComponent:2] == 0];
}

- (void)nextVC
{
    [self presentViewController:[RootViewController new] animated:NO completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)createCollectionView
{
    UILabel *plan = [[UILabel alloc] initWithFrame:CGRectMake(20, 120, 280, 40)];
    plan.textAlignment = NSTextAlignmentCenter;
    plan.textColor = [UIColor whiteColor];
    plan.text = @"pick a plan";
    plan.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:30];
    plan.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:plan];

    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 170, 320, 120) collectionViewLayout:flow];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[PRCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:_collectionView];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PRCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];

    cell.contentView.layer.borderColor = indexPath.item != _selectedIndex ? [UIColor clearColor].CGColor : [UIColor whiteColor].CGColor;

    if (indexPath.item == 0)
    {
        cell.backgroundColor = [UIColor colorWithRed:0.541 green:0.475 blue:0.365 alpha:1.0];
        cell.planNameLabel.text = @"Apartment";
        cell.bedNbathLabel.text = @"1-2 bedrooms";
        cell.costLabel.text = @"$150/month";
    }
    else if (indexPath.item == 1)
    {
        cell.backgroundColor = [UIColor colorWithRed:0.651 green:0.651 blue:0.651 alpha:1.0];
        cell.planNameLabel.text = @"Small Home";
        cell.bedNbathLabel.text = @"3-4 bedrooms";
        cell.costLabel.text = @"$300/month";
    }
    else if (indexPath.item == 2)
    {
        cell.backgroundColor = [UIColor colorWithRed:0.765 green:0.600 blue:0.325 alpha:1.0];
        cell.planNameLabel.text = @"Large Home";
        cell.bedNbathLabel.text = @"5-6 bedrooms";
        cell.costLabel.text = @"$450/month";
    }
    else
    {
        cell.backgroundColor = [UIColor colorWithRed:0.459 green:0.459 blue:0.459 alpha:1.0];
        cell.planNameLabel.text = @"Mansion";
        cell.bedNbathLabel.text = @"7-8 bedrooms";
        cell.costLabel.text = @"$600/month";
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(120,120);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    for (UICollectionViewCell *cell in collectionView.visibleCells)
    {
        cell.contentView.layer.borderColor = [UIColor clearColor].CGColor;
    }

    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.contentView.layer.borderWidth = 1;
    cell.contentView.layer.borderColor = [UIColor whiteColor].CGColor;
    _selectedIndex = indexPath.item;

    _save.enabled = [self enableSaveButton];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _save.enabled = [self enableSaveButton];
}

- (BOOL)enableSaveButton
{
    if ([self firstTime])
    {
        if (_selectedIndex != -1)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    else if ([self dateChanged])
    {
        return YES;
    }
    else
    {
        if ([self planChanged])
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
}

- (BOOL)firstTime
{
    return ![User plan] ? YES : NO;
}

- (BOOL)dateChanged
{
    BOOL day = [[User day] isEqualToString:_days[[_dayPicker selectedRowInComponent:0]]];
    BOOL hour = [User hour] == [_timePicker selectedRowInComponent:0]+1;
    BOOL minute = [User minute] == [_timePicker selectedRowInComponent:1];
    BOOL am = ([User AM] ? 0 : 1) == [_timePicker selectedRowInComponent:2];

    return !(day && hour && minute && am);
}

- (BOOL)planChanged
{
    return _selectedIndex != [User plan];
}

- (void)createSubscription
{
    [PFCloud callFunctionInBackground:@"createSubscription"
                       withParameters:@{@"customer":[User customerId], @"plan":@([User plan]).description}
                                block:^(NSString *subscriptionId, NSError *error)
     {
         if (error)
         {
             _save.enabled = YES;
             [self displayErrorAlert];
         }
         else
         {
             [User setSubscriptionId:subscriptionId];
             [self saveValues];
             [ParseLogic addUserToDataBase];
             [ParseLogic createVisits];
             [self nextVC];
         }
     }];
}

- (void)displayErrorAlert
{
    [[[UIAlertView alloc] initWithTitle:@"Error trying to subscribe" message:@"Please try again with a good network connection and a working card" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}

@end
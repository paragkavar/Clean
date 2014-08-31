//
//  SubscribeViewController.m
//  Clean
//
//  Created by Sapan Bhuta on 8/29/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#define specialBlueColor [UIColor colorWithRed:0.0f green:0.49f blue:0.96f alpha:1.0f]

#import "SubscribeViewController.h"
#import "RootViewController.h"
#import "JSQFlatButton.h"
#import "UIColor+FlatUI.h"
#import <Parse/Parse.h>
#import "VCFlow.h"

@interface SubscribeViewController () <UIPickerViewDataSource, UIPickerViewDelegate>
@property JSQFlatButton *subscribe;
@property JSQFlatButton *later;
@property NSArray *planButtons;
@property UIPickerView *planPicker;
@property int selectedPlan;
@property int bedrooms;
@property int bathrooms;
@property UILabel *costLabel;
@end

@implementation SubscribeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor midnightBlueColor];
    _selectedPlan = -1;
    _bedrooms = [[[NSUserDefaults standardUserDefaults] objectForKey:@"bedrooms"] intValue];
    _bathrooms = [[[NSUserDefaults standardUserDefaults] objectForKey:@"bathrooms"] intValue];
    [self createPage];
    [self createTitle];
    [self createButton];
    [self createPlans];
    [self createLabels];
}

- (void)createPage
{
    UIPageControl *page = [[UIPageControl alloc] init];
    page.center = CGPointMake(self.view.center.x, 100);
    page.numberOfPages = 7;
    page.currentPage = 6;
    page.backgroundColor = [UIColor clearColor];
    page.tintColor = [UIColor whiteColor];
    page.currentPageIndicatorTintColor = [UIColor colorWithRed:0.0f green:0.49f blue:0.96f alpha:1.0f];
    [self.view addSubview:page];
}

- (void)createTitle
{
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, self.view.frame.size.width-2*10, 50)];
    title.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:50];
    title.textColor = [UIColor whiteColor];
    title.text = @"Subscribe";
    title.adjustsFontSizeToFitWidth = YES;
    title.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:title];
}

- (void)createLabels
{
    UILabel *visits = [[UILabel alloc] initWithFrame:CGRectMake(10, 150, self.view.frame.size.width-2*10, 50)];
    visits.center = CGPointMake(visits.center.x, _planPicker.center.y);
    visits.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:25];
    visits.textColor = [UIColor whiteColor];
    visits.text = @"Visits Per Month:";
    visits.adjustsFontSizeToFitWidth = YES;
    visits.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:visits];

    _costLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 200, self.view.frame.size.width-2*10, 50)];
    _costLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:25];
    _costLabel.textColor = [UIColor whiteColor];
    _costLabel.text = @"Cost: $0/month";
    _costLabel.adjustsFontSizeToFitWidth = YES;
    _costLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_costLabel];
}

- (void)createButton
{
    CGRect frame = CGRectMake(0, self.view.frame.size.height-54, self.view.frame.size.width, 54);

    _subscribe = [[JSQFlatButton alloc] initWithFrame:frame
                                      backgroundColor:[UIColor whiteColor]
                                      foregroundColor:[UIColor colorWithRed:0.35f green:0.35f blue:0.81f alpha:1.0f]
                                                title:@"subscribe"
                                                image:nil];
    _subscribe.disabledBackgroundColor = [UIColor lightGrayColor];
    _subscribe.highlightedBackgroundColor = [UIColor clearColor];
    [_subscribe addTarget:self action:@selector(subscribe:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_subscribe];
    _subscribe.enabled = NO;
}

- (void)createPlans
{
    _planPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(200, 100, 120, 100)];
    _planPicker.delegate = self;
    _planPicker.dataSource = self;
    [self.view addSubview:_planPicker];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 10;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@(row).description];
    [title addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [title length])];
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _subscribe.enabled = row > 0;
    _selectedPlan = row;
    [self calcCost];
}

- (void)calcCost
{
    [PFCloud callFunctionInBackground:@"costCalc"
                       withParameters:@{@"visits":@(_selectedPlan), @"bedrooms":@(_bedrooms), @"bathrooms":@(_bathrooms)}
                                block:^(NSNumber *cost, NSError *error)
     {
        _costLabel.text = [NSString stringWithFormat:@"Cost: $%@/month",cost];
     }];
}

- (void)subscribe:(JSQFlatButton *)sender
{
    _subscribe.enabled = NO;
    [[NSUserDefaults standardUserDefaults] setObject:@(_selectedPlan) forKey:@"visits"];

    NSString *customer = [[NSUserDefaults standardUserDefaults] objectForKey:@"customerId"];

    [PFCloud callFunctionInBackground:@"costCalc"
                       withParameters:@{@"visits":@(_selectedPlan), @"bedrooms":@(_bedrooms), @"bathrooms":@(_bathrooms)}
                                block:^(NSNumber *cost, NSError *error)
    {
        [PFCloud callFunctionInBackground:@"createSubscription"
                           withParameters:@{@"customer":customer,
                                            @"plan":[NSString stringWithFormat:@"%@",cost]}
                                    block:^(NSString *subscriptionId, NSError *error)
         {
             if (error)
             {
                 _subscribe.enabled = YES;
                 [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please check network connection and try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
             }
             else
             {
                 [[NSUserDefaults standardUserDefaults] setObject:subscriptionId forKey:@"subscriptionId"];
                 [VCFlow addUserToDataBase];
                 [self presentViewController:[RootViewController new] animated:NO completion:nil];
             }
         }];
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end

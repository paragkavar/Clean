//
//  GetHomeInfoViewController.m
//  Clean
//
//  Created by Sapan Bhuta on 8/29/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#import "GetPriceViewController.h"
#import "GetPaymentCardViewController.h"
#import "JSQFlatButton.h"
#import "UIColor+FlatUI.h"
#import <Parse/Parse.h>

@interface GetPriceViewController () <UIPickerViewDataSource, UIPickerViewDelegate>
@property UIPickerView *bedroomPicker;
@property UIPickerView *bathroomPicker;
@property UIPickerView *visitsPicker;
@property JSQFlatButton *save;
@property UILabel *costLabel;
@end

@implementation GetPriceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor midnightBlueColor];
    [self createPage];
    [self createTitle];
    [self createButton];
    [self createPickers];
}

- (void)createPage
{
    UIPageControl *page = [[UIPageControl alloc] init];
    page.center = CGPointMake(self.view.center.x, 100);
    page.numberOfPages = 5;
    page.currentPage = 3;
    page.backgroundColor = [UIColor clearColor];
    page.tintColor = [UIColor whiteColor];
    page.currentPageIndicatorTintColor = [UIColor colorWithRed:0.0f green:0.49f blue:0.96f alpha:1.0f];
    [self.view addSubview:page];
}

- (void)createTitle
{
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, self.view.frame.size.width-2*10, 50)];
    title.text = @"Price";
    title.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:50];
    title.textColor = [UIColor whiteColor];
    title.adjustsFontSizeToFitWidth = YES;
    title.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:title];
}

- (void)createButton
{
    _save = [[JSQFlatButton alloc] initWithFrame:CGRectMake(0,
                                                            self.view.frame.size.height-54,
                                                            self.view.frame.size.width,
                                                            54)
                                 backgroundColor:[UIColor colorWithRed:1.00f green:1.00f blue:1.00f alpha:1.0f]
                                 foregroundColor:[UIColor colorWithRed:0.35f green:0.35f blue:0.81f alpha:1.0f]
                                           title:@"pick"
                                           image:nil];
    [_save addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_save];
}

- (void)createPickers
{
    UILabel *bedroom = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, 140, 50)];
    bedroom.text = @"# of bedrooms";
    bedroom.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:50];
    bedroom.textColor = [UIColor whiteColor];
    bedroom.adjustsFontSizeToFitWidth = YES;
    bedroom.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:bedroom];

    UILabel *bathroom = [[UILabel alloc] initWithFrame:CGRectMake(10, 200, 140, 50)];
    bathroom.text = @"# of bathrooms";
    bathroom.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:50];
    bathroom.textColor = [UIColor whiteColor];
    bathroom.adjustsFontSizeToFitWidth = YES;
    bathroom.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:bathroom];

    UILabel *visits = [[UILabel alloc] initWithFrame:CGRectMake(10, 300, 140, 50)];
    visits.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:50];
    visits.textColor = [UIColor whiteColor];
    visits.text = @"# of visits/month:";
    visits.adjustsFontSizeToFitWidth = YES;
    visits.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:visits];

    _bedroomPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(100, 100, 40, 60)];
    _bedroomPicker.center = CGPointMake(200, bedroom.center.y+10);
    _bedroomPicker.delegate = self;
    _bedroomPicker.dataSource = self;
    [self.view addSubview:_bedroomPicker];
    _bedroomPicker.tag = 1;

    _bathroomPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(150, 100, 40, 60)];
    _bathroomPicker.center = CGPointMake(200, bathroom.center.y+10);
    _bathroomPicker.delegate = self;
    _bathroomPicker.dataSource = self;
    [self.view addSubview:_bathroomPicker];
    _bedroomPicker.tag = 1;

    _visitsPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(200, 100, 40, 60)];
    _visitsPicker.center = CGPointMake(200, visits.center.y);
    _visitsPicker.delegate = self;
    _visitsPicker.dataSource = self;
    [self.view addSubview:_visitsPicker];
    _visitsPicker.tag = 0;

    _costLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 400, self.view.frame.size.width-2*10, 50)];
    _costLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:50];
    _costLabel.textColor = [UIColor whiteColor];
    _costLabel.text = @"Cost: $20/month";
    _costLabel.adjustsFontSizeToFitWidth = YES;
    _costLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_costLabel];
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
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@(row+1).description];
    [title addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [title length])];
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self calcCost];
}

- (void)calcCost
{
    [PFCloud callFunctionInBackground:@"costCalc"
                       withParameters:@{@"visits":@([_visitsPicker selectedRowInComponent:0]+1),
                                        @"bedrooms":@([_bedroomPicker selectedRowInComponent:0]+1),
                                        @"bathrooms":@([_bedroomPicker selectedRowInComponent:0]+1)}
                                block:^(NSNumber *cost, NSError *error)
     {
         _costLabel.text = [NSString stringWithFormat:@"Cost: $%@/month",cost];
     }];
}

- (void)save:(JSQFlatButton *)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:@([_bedroomPicker selectedRowInComponent:0]+1) forKey:@"bedrooms"];
    [[NSUserDefaults standardUserDefaults] setObject:@([_bathroomPicker selectedRowInComponent:0]+1) forKey:@"bathrooms"];
    [[NSUserDefaults standardUserDefaults] setObject:@([_visitsPicker selectedRowInComponent:0]+1) forKey:@"visits"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self presentViewController:[GetPaymentCardViewController new] animated:NO completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
//
//  GetHomeInfoViewController.m
//  Clean
//
//  Created by Sapan Bhuta on 8/29/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#import "GetHomeInfoViewController.h"
#import "GetPaymentCardViewController.h"
#import "JSQFlatButton.h"
#import "UIColor+FlatUI.h"

@interface GetHomeInfoViewController () <UIPickerViewDataSource, UIPickerViewDelegate>
@property UIPickerView *bedroomPicker;
@property UIPickerView *bathroomPicker;
@property JSQFlatButton *save;
@end

@implementation GetHomeInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor midnightBlueColor];
    [self createTitle];
    [self createButton];
    [self createPickers];
}

- (void)createTitle
{
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, self.view.frame.size.width-2*10, 50)];
    title.text = @"About";
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
                                           title:@"save"
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

    UILabel *bathroom = [[UILabel alloc] initWithFrame:CGRectMake(170, 100, 140, 50)];
    bathroom.text = @"# of bathrooms";
    bathroom.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:50];
    bathroom.textColor = [UIColor whiteColor];
    bathroom.adjustsFontSizeToFitWidth = YES;
    bathroom.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:bathroom];

    _bedroomPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(100, 100, 40, 60)];
    _bedroomPicker.center = CGPointMake(bedroom.center.x, 175);
    _bedroomPicker.delegate = self;
    _bedroomPicker.dataSource = self;
    [self.view addSubview:_bedroomPicker];

    _bathroomPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(220, 100, 40, 60)];
    _bathroomPicker.center = CGPointMake(bathroom.center.x, 175);
    _bathroomPicker.delegate = self;
    _bathroomPicker.dataSource = self;
    [self.view addSubview:_bathroomPicker];
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

- (void)save:(JSQFlatButton *)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:@([_bedroomPicker selectedRowInComponent:0]+1).description forKey:@"bedrooms"];
    [[NSUserDefaults standardUserDefaults] setObject:@([_bathroomPicker selectedRowInComponent:0]+1).description forKey:@"bathrooms"];
    [self presentViewController:[GetPaymentCardViewController new] animated:NO completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end

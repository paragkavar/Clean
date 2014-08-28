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

@interface RootViewController ()
@property JSQFlatButton *clean;
@property UIDatePicker *datePicker;
@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor midnightBlueColor];
    [self createTitle];
    [self createDatePicker];
    [self createButton];
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

- (void)createButton
{
    self.clean = [[JSQFlatButton alloc] initWithFrame:buttonFrame
                                      backgroundColor:[UIColor colorWithRed:0.18f green:0.67f blue:0.84f alpha:1.0f]
                                      foregroundColor:[UIColor colorWithRed:0.35f green:0.35f blue:0.81f alpha:1.0f]
                                                title:@"Clean"
                                                image:nil];
    [self.clean addTarget:self action:@selector(clean:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.clean];
}

- (void)clean:(JSQFlatButton *)sender
{
    if (NO) //on service
    {

    }
    else //go to charge
    {

    }
}

- (NSString *)getDate
{
    NSLocale *usLocale = [[NSLocale alloc]
                          initWithLocaleIdentifier:@"en_US"];

    NSDate *pickerDate = [_datePicker date];
    NSString *selectionString = [[NSString alloc]
                                 initWithFormat:@"%@",
                                 [pickerDate descriptionWithLocale:usLocale]];
    return selectionString;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end

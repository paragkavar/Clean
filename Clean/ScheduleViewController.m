//
//  ScheduleViewController.m
//  Clean
//
//  Created by Sapan Bhuta on 9/6/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#import "ScheduleViewController.h"
#import "UIColor+FlatUI.h"
#import "RQScrollView.h"
#import "JSQFlatButton.h"

@interface ScheduleViewController ()
@property JSQFlatButton *cancel;
@property JSQFlatButton *schedule;
@end

@implementation ScheduleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor midnightBlueColor];
    [self createTitle];
    [self createButtons];
    [self createContent];
}

- (void)createContent
{
    RQScrollView *rqview = [[RQScrollView alloc] initWithFrame:CGRectMake(0, 90, self.view.frame.size.width, self.view.frame.size.height-90-54)];
    [self.view addSubview:rqview];
}

- (void)createTitle
{
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, self.view.frame.size.width-2*10, 50)];
    title.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:50];
    title.textColor = [UIColor whiteColor];
    title.text = @"Schedule";
    title.adjustsFontSizeToFitWidth = YES;
    title.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:title];
}

- (void)createButtons
{
    _cancel = [[JSQFlatButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-54, self.view.frame.size.width/2-.25, 54)
                                   backgroundColor:[UIColor colorWithRed:0.18f green:0.67f blue:0.84f alpha:1.0f]
                                   foregroundColor:[UIColor colorWithRed:1.00f green:1.00f blue:1.00f alpha:1.0f]
                                             title:@"cancel"
                                             image:nil];
    [_cancel addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancel];

    _schedule = [[JSQFlatButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2+.25, self.view.frame.size.height-54, self.view.frame.size.width/2-.25, 54)
                                     backgroundColor:[UIColor colorWithRed:1.00f green:1.00f blue:1.00f alpha:1.0f]
                                     foregroundColor:[UIColor colorWithRed:0.35f green:0.35f blue:0.81f alpha:1.0f]
                                               title:@"schedule"
                                               image:nil];
    [_schedule addTarget:self action:@selector(schedule:) forControlEvents:UIControlEventTouchUpInside];
    _schedule.enabled = NO;
    [self.view addSubview:_schedule];
}

- (void)cancel:(JSQFlatButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)schedule:(JSQFlatButton *)sender
{
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end

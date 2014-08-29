//
//  IntroViewController.m
//  Clean
//
//  Created by Sapan Bhuta on 8/28/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#import "IntroViewController.h"
#import "GetPhoneNumberViewController.h"
#import "JSQFlatButton.h"
#import "UIColor+FlatUI.h"
#import "SBLabel.h"

@interface IntroViewController ()
@property JSQFlatButton *start;
@end

@implementation IntroViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor midnightBlueColor];
    [self createTitle];
    [self createButton];
}

- (void)createTitle
{
    SBLabel *title = [[SBLabel alloc] initWithFrame:CGRectMake(10, 30, self.view.frame.size.width-2*10, 50)];
    title.text = @"Welcome!";
    [self.view addSubview:title];
}

- (void)createButton
{
    _start = [[JSQFlatButton alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height-54,self.view.frame.size.width,54)
                                      backgroundColor:[UIColor colorWithRed:1.00f green:1.00f blue:1.00f alpha:1.0f]
                                      foregroundColor:[UIColor colorWithRed:0.35f green:0.35f blue:0.81f alpha:1.0f]
                                                title:@"start"
                                                image:nil];
    [_start addTarget:self action:@selector(start:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_start];
}

- (void)start:(JSQFlatButton *)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"started"];
    [self presentViewController:[GetPhoneNumberViewController new] animated:NO completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end

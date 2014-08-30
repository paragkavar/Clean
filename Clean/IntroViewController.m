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

@interface IntroViewController ()
@property JSQFlatButton *start;
@end

@implementation IntroViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor midnightBlueColor];
    [self createPage];
    [self createTitle];
    [self createButton];
}

- (void)createPage
{
    UIPageControl *page = [[UIPageControl alloc] init];
    page.center = CGPointMake(self.view.center.x, 100);
    page.numberOfPages = 7;
    page.currentPage = 0;
    page.backgroundColor = [UIColor clearColor];
    page.tintColor = [UIColor whiteColor];
    page.currentPageIndicatorTintColor = [UIColor colorWithRed:0.0f green:0.49f blue:0.96f alpha:1.0f];
    [self.view addSubview:page];
}

- (void)createTitle
{
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, self.view.frame.size.width-2*10, 50)];
    title.text = @"Welcome!";
    title.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:50];
    title.textColor = [UIColor whiteColor];
    title.adjustsFontSizeToFitWidth = YES;
    title.textAlignment = NSTextAlignmentCenter;
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

//
//  SettingsViewController.m
//  Clean
//
//  Created by Sapan Bhuta on 9/1/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#import "SettingsViewController.h"
#import "UIColor+FlatUI.h"
#import "JSQFlatButton.h"
#import "SetPhoneViewController.h"
#import "SetAddressViewController.h"
#import "SetPlanViewController.h"
#import "SetPayCardViewController.h"

@interface SettingsViewController ()
@property JSQFlatButton *back;
@property UIButton *phone;
@property UIButton *address;
@property UIButton *plan;
@property UIButton *card;
@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor midnightBlueColor];
    [self createTitle];
    [self createButton];
    [self createPhone];
    [self createAddress];
    [self createPlan];
    [self createCard];
#warning show values for all icons
}

- (void)createPhone
{
    _phone = [UIButton buttonWithType:UIButtonTypeSystem];
    _phone.frame = CGRectMake(20, 20, 64, 64);
    _phone.center = CGPointMake(self.view.center.x, 150);
    _phone.tintColor = [UIColor whiteColor];
    [_phone setImage:[UIImage imageNamed:@"telephone"] forState:UIControlStateNormal];
    [_phone addTarget:self action:@selector(phone:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_phone];
}

- (void)phone:(UIButton *)sender
{
//    [self presentViewController:[SetPhoneViewController new] animated:NO completion:nil];
}

- (void)createAddress
{
    _address = [UIButton buttonWithType:UIButtonTypeSystem];
    _address.frame = CGRectMake(20, 20, 64, 64);
    _address.center = CGPointMake(self.view.center.x, 250);
    _address.tintColor = [UIColor whiteColor];
    [_address setImage:[UIImage imageNamed:@"navigate"] forState:UIControlStateNormal];
    [_address addTarget:self action:@selector(address:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_address];
}

- (void)address:(UIButton *)sender
{
//    [self presentViewController:[SetAddressViewController new] animated:NO completion:nil];
}

- (void)createPlan
{
    _plan = [UIButton buttonWithType:UIButtonTypeSystem];
    _plan.frame = CGRectMake(20, 20, 64, 64);
    _plan.center = CGPointMake(self.view.center.x, 350);
    _plan.tintColor = [UIColor whiteColor];
    [_plan setImage:[UIImage imageNamed:@"calendar"] forState:UIControlStateNormal];
    [_plan addTarget:self action:@selector(plan:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_plan];
}

- (void)plan:(UIButton *)sender
{
//    [self presentViewController:[SetPlanViewController new] animated:NO completion:nil];
}

- (void)createCard
{
    _card = [UIButton buttonWithType:UIButtonTypeSystem];
    _card.frame = CGRectMake(20, 20, 64, 64);
    _card.center = CGPointMake(self.view.center.x, 450);
    _card.tintColor = [UIColor whiteColor];
    [_card setImage:[UIImage imageNamed:@"credit-card"] forState:UIControlStateNormal];
    [_card addTarget:self action:@selector(card:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_card];
}

- (void)card:(UIButton *)sender
{
//    [self presentViewController:[SetPayCardViewController new] animated:NO completion:nil];
}

- (void)createTitle
{
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, self.view.frame.size.width-2*10, 50)];
    title.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:40];
    title.textColor = [UIColor whiteColor];
    title.text = @"Settings";
    title.adjustsFontSizeToFitWidth = YES;
    title.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:title];
}

- (void)createButton
{
    _back = [[JSQFlatButton alloc] initWithFrame:CGRectMake(0,
                                                            self.view.frame.size.height-54,
                                                            self.view.frame.size.width,
                                                            54)
                                   backgroundColor:[UIColor colorWithRed:1.00f green:1.00f blue:1.00f alpha:1.0f]
                                   foregroundColor:[UIColor colorWithRed:0.35f green:0.35f blue:0.81f alpha:1.0f]
                                             title:@"back"
                                             image:nil];
    [_back addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_back];
}

- (void)back:(JSQFlatButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"spin" object:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
@end

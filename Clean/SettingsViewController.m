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
#import "User.h"

@interface SettingsViewController ()
@property JSQFlatButton *back;
@property UIButton *phone;
@property UIButton *address;
@property UIButton *plan;
@property UIButton *card;
@property UILabel *phoneLabel;
@property UILabel *addressLabel;
@property UILabel *planLabel;
@property UILabel *cardLabel;
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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _phoneLabel.text = [self formattedPhoneNumber];
    _addressLabel.text = [@" " stringByAppendingString:[User address]];
    _planLabel.text = [self formattedPlanDescription];
    _cardLabel.text = [NSString stringWithFormat:@" **** **** %@",[User last4]];
}

- (NSString *)formattedPhoneNumber
{
    NSMutableString *mutNumber1 = [[User phoneNumber] mutableCopy];
    NSMutableString *mutNumber2 = [[mutNumber1 substringFromIndex:1] mutableCopy];
    [mutNumber2 insertString:@"(" atIndex:0];
    [mutNumber2 insertString:@")" atIndex:4];
    [mutNumber2 insertString:@" " atIndex:5];
    [mutNumber2 insertString:@"-" atIndex:9];
    return mutNumber2;
}

- (NSString *)formattedPlanDescription
{
    int plan = [User plan];
    NSString *description;

    if (plan == 0)
    {
        description = @" $150/month";
    }
    else if (plan == 1)
    {
        description = @" $300/month";
    }
    else if (plan == 2)
    {
        description = @" $450/month";
    }
    else if (plan == 3)
    {
        description = @" $600/month";
    }
    else
    {
        description = @"no plan";
    }

    return description;
}

- (void)createPhone
{
    _phone = [UIButton buttonWithType:UIButtonTypeSystem];
    _phone.frame = CGRectMake(20, 20, 64, 64);
    _phone.center = CGPointMake(self.view.center.x/3, 130);
    _phone.tintColor = [UIColor whiteColor];
    [_phone setImage:[UIImage imageNamed:@"telephone"] forState:UIControlStateNormal];
    [_phone addTarget:self action:@selector(phone:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_phone];

    _phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(_phone.frame.origin.x+_phone.frame.size.width,
                                                           _phone.frame.origin.y,
                                                           self.view.frame.size.width-(_phone.frame.origin.x+_phone.frame.size.width),
                                                           _phone.frame.size.height)];
    _phoneLabel.textColor = [UIColor whiteColor];
    _phoneLabel.textAlignment = NSTextAlignmentLeft;
    _phoneLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:30];
    [self.view addSubview:_phoneLabel];
}

- (void)phone:(UIButton *)sender
{
    [self presentViewController:[SetPhoneViewController new] animated:YES completion:nil];
}

- (void)createAddress
{
    _address = [UIButton buttonWithType:UIButtonTypeSystem];
    _address.frame = CGRectMake(20, 20, 64, 64);
    _address.center = CGPointMake(self.view.center.x/3, 230);
    _address.tintColor = [UIColor whiteColor];
    [_address setImage:[UIImage imageNamed:@"navigate"] forState:UIControlStateNormal];
    [_address addTarget:self action:@selector(address:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_address];

    _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(_address.frame.origin.x+_phone.frame.size.width,
                                                              _address.frame.origin.y,
                                                              self.view.frame.size.width-(_address.frame.origin.x+_address.frame.size.width),
                                                              _address.frame.size.height)];
    _addressLabel.textColor = [UIColor whiteColor];
    _addressLabel.textAlignment = NSTextAlignmentLeft;
    _addressLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:30];
    [self.view addSubview:_addressLabel];
}

- (void)address:(UIButton *)sender
{
    [self presentViewController:[SetAddressViewController new] animated:YES completion:nil];
}

- (void)createPlan
{
    _plan = [UIButton buttonWithType:UIButtonTypeSystem];
    _plan.frame = CGRectMake(20, 20, 64, 64);
    _plan.center = CGPointMake(self.view.center.x/3, 330);
    _plan.tintColor = [UIColor whiteColor];
    [_plan setImage:[UIImage imageNamed:@"calendar"] forState:UIControlStateNormal];
    [_plan addTarget:self action:@selector(plan:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_plan];

    _planLabel = [[UILabel alloc] initWithFrame:CGRectMake(_plan.frame.origin.x+_plan.frame.size.width,
                                                           _plan.frame.origin.y,
                                                           self.view.frame.size.width-(_plan.frame.origin.x+_plan.frame.size.width),
                                                           _plan.frame.size.height)];
    _planLabel.textColor = [UIColor whiteColor];
    _planLabel.textAlignment = NSTextAlignmentLeft;
    _planLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:30];
    [self.view addSubview:_planLabel];
}

- (void)plan:(UIButton *)sender
{
    [self presentViewController:[SetPlanViewController new] animated:YES completion:nil];
}

- (void)createCard
{
    _card = [UIButton buttonWithType:UIButtonTypeSystem];
    _card.frame = CGRectMake(20, 20, 64, 64);
    _card.center = CGPointMake(self.view.center.x/3, 430);
    _card.tintColor = [UIColor whiteColor];
    [_card setImage:[UIImage imageNamed:@"credit-card"] forState:UIControlStateNormal];
    [_card addTarget:self action:@selector(card:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_card];

    _cardLabel = [[UILabel alloc] initWithFrame:CGRectMake(_card.frame.origin.x+_card.frame.size.width,
                                                           _card.frame.origin.y,
                                                           self.view.frame.size.width-(_card.frame.origin.x+_card.frame.size.width),
                                                           _card.frame.size.height)];
    _cardLabel.textColor = [UIColor whiteColor];
    _cardLabel.textAlignment = NSTextAlignmentLeft;
    _cardLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:30];
    [self.view addSubview:_cardLabel];
}

- (void)card:(UIButton *)sender
{
    [self presentViewController:[SetPayCardViewController new] animated:YES completion:nil];
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

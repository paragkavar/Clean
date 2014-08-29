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

@interface GetHomeInfoViewController ()
@property UIPickerView *bedroomPicker;
@property UIPickerView *bathroomPicker;
@property JSQFlatButton *save;
@end

@implementation GetHomeInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor midnightBlueColor];
    [self createButton];
    [self createPickers];
}

- (void)createButton
{
    _save = [[JSQFlatButton alloc] initWithFrame:CGRectMake(0,
                                                            self.view.frame.size.height-216-54,
                                                            self.view.frame.size.width,
                                                            54)
                                 backgroundColor:[UIColor colorWithRed:1.00f green:1.00f blue:1.00f alpha:1.0f]
                                 foregroundColor:[UIColor colorWithRed:0.35f green:0.35f blue:0.81f alpha:1.0f]
                                           title:@"save"
                                           image:nil];
    [_save addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_save];
    _save.enabled = NO;
}

- (void)createPickers
{
    
}

- (void)save:(JSQFlatButton *)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:@([_bedroomPicker selectedRowInComponent:0]).description forKey:@"bedrooms"];
    [[NSUserDefaults standardUserDefaults] setObject:@([_bathroomPicker selectedRowInComponent:0]).description forKey:@"bathrooms"];
    [self presentViewController:[GetPaymentCardViewController new] animated:NO completion:nil];
}

@end

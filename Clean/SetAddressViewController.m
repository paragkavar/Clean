//
//  SetAddressViewController.m
//  Clean
//
//  Created by Sapan Bhuta on 9/1/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#import "SetAddressViewController.h"
#import "GetPriceViewController.h"
#import "JSQFlatButton.h"
#import "UIColor+FlatUI.h"
#import "INTULocationManager.h"

@interface SetAddressViewController () <UIAlertViewDelegate>
@property JSQFlatButton *back;
@property JSQFlatButton *save;
@end

@implementation SetAddressViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createNewButton];
#warning hide pagecontrol
}

- (void)createNewButton
{
    _back = [[JSQFlatButton alloc] initWithFrame:CGRectMake(0,
                                                            self.view.frame.size.height-216-54,
                                                            self.view.frame.size.width/2-.25,
                                                            54)
                                 backgroundColor:[UIColor colorWithRed:0.18f green:0.67f blue:0.84f alpha:1.0f]
                                 foregroundColor:[UIColor colorWithRed:1.00f green:1.00f blue:1.00f alpha:1.0f]
                                           title:@"back"
                                           image:nil];
    [_back addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_back];

    super.save.frame = CGRectMake(self.view.frame.size.width/2+.25,
                             self.view.frame.size.height-216-54,
                             self.view.frame.size.width/2-.25,
                             54);
}

- (void)back:(JSQFlatButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)nextVC
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#warning update Parse
@end

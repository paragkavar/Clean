//
//  SetAddressViewController.m
//  Clean
//
//  Created by Sapan Bhuta on 9/1/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#import "SetAddressViewController.h"
#import "GetPlanViewController.h"
#import "VCFlow.h"
#import "JSQFlatButton.h"
#import "UIColor+FlatUI.h"
#import "INTULocationManager.h"

@interface SetAddressViewController () <UIAlertViewDelegate>
@end

@implementation SetAddressViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createNewButton];
    super.page.hidden = YES;
}

- (void)createNewButton
{
    super.back.frame = CGRectMake(0, self.view.frame.size.height-216-54, self.view.frame.size.width/2-.25, 54);
    super.save.frame = CGRectMake(self.view.frame.size.width/2+.25,self.view.frame.size.height-216-54,self.view.frame.size.width/2-.25,54);
}

- (void)nextVC
{
    [VCFlow updateUserInParse];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

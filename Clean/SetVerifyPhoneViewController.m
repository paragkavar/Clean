//
//  SetVerifyPhoneViewController.m
//  Clean
//
//  Created by Sapan Bhuta on 9/1/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#import "SetVerifyPhoneViewController.h"
#import "UIColor+FlatUI.h"
#import "JSQFlatButton.h"
#import <Parse/Parse.h>
#import "VCFlow.h"

@interface SetVerifyPhoneViewController ()
@property UITextField *codeEntry;
@property NSTimer *buttonCheckTimer;
@property JSQFlatButton *resend;
@property JSQFlatButton *enter;
@property int randomNum;
@end

@implementation SetVerifyPhoneViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    super.page.numberOfPages = 2;
}

- (NSString *)testNumber
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"setPhoneNumber"];
}

- (void)back:(JSQFlatButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)enter:(JSQFlatButton *)sender
{
    NSString *newNum = [[NSUserDefaults standardUserDefaults] objectForKey:@"setPhoneNumber"];
    [[NSUserDefaults standardUserDefaults] setObject:newNum forKey:@"phoneNumber"];
    [VCFlow updateUserInParse];
    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
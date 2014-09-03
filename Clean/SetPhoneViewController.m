//
//  SetPhoneViewController.m
//  Clean
//
//  Created by Sapan Bhuta on 9/1/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#import "SetPhoneViewController.h"
#import "SetVerifyPhoneViewController.h"
#import "UIColor+FlatUI.h"
#import "JSQFlatButton.h"

@interface SetPhoneViewController () <UITextFieldDelegate>
@property JSQFlatButton *cancel;
@end

@implementation SetPhoneViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createNewButtons];
    super.page.numberOfPages = 2;
}

- (void)createNewButtons
{
    _cancel = [[JSQFlatButton alloc] initWithFrame:CGRectMake(0,
                                                              self.view.frame.size.height-216-54,
                                                              self.view.frame.size.width/2-.25,
                                                              54)
                                   backgroundColor:[UIColor colorWithRed:0.18f green:0.67f blue:0.84f alpha:1.0f]
                                   foregroundColor:[UIColor colorWithRed:1.00f green:1.00f blue:1.00f alpha:1.0f]
                                             title:@"back"
                                             image:nil];
    [_cancel addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancel];

    super.verify.frame = CGRectMake(self.view.frame.size.width/2+.25,
                                    self.view.frame.size.height-216-54,
                                    self.view.frame.size.width/2-.25,
                                    54);
}

- (void)saveTempPhoneNumber:(NSString *)number
{
    [[NSUserDefaults standardUserDefaults] setObject:number forKey:@"setPhoneNumber"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)cancel:(JSQFlatButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)nextVC
{
    [self presentViewController:[SetVerifyPhoneViewController new] animated:NO completion:nil];
}

@end